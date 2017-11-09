//
//  RxNetworkLayer.swift
//  Umbrella
//
//  Created by Jonathan Jones on 10/24/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//
import RxSwift
import Foundation

let apiKey = "833018b6135efd73"

enum HourlySet {
    case today
    case tomorrow
    case other
}


class RxNetworkLayer {
    static func getWeatherRequest(forZip zipCode: String) throws -> URL {
        guard let weatherRequest = WeatherRequest(APIKey: apiKey, zipCode: zipCode) else {
            throw NetworkError.invalidURL
        }
        return weatherRequest.URL
    }
    
    static let shared = RxNetworkLayer(with: "60647")
    public var currentZipcode = PublishSubject<String>()
    
    public var totalWeather: BehaviorSubject<[HourlyWeather]> = BehaviorSubject(value: [])
    private var bag = DisposeBag()

    open var todaysWeather: Observable<SectionOfHourlyData> {
        return self.totalWeather
            .asObservable()
            .map({ (allWeather) -> SectionOfHourlyData in
                let weather = allWeather.filter { return $0.isToday }
                return SectionOfHourlyData(header: "Today", items: weather)
            })
    }
    
    open var tomorrowsWeather: Observable<SectionOfHourlyData> {
        return self.totalWeather
            .asObservable()
            .map({ (allWeather) -> SectionOfHourlyData in
                let weather = allWeather.filter { return $0.isTomorrow }
                print(weather.count)
                return SectionOfHourlyData(header: "Tomorrow", items: weather)
            })
    }
    
    open var otherWeather: Observable<SectionOfHourlyData> {
        return self.totalWeather
            .asObservable()
            .map({ (allWeather) -> SectionOfHourlyData in
                let weather = allWeather.filter { return !$0.isToday && !$0.isTomorrow }
                return SectionOfHourlyData(header: "Two Days From Now", items: weather)
                
            })
    }
    
    private init(with zipCode: String) {
        subscribeToCurrentZipcode()
        currentZipcode.onNext(zipCode)
    }
    
    func subscribeToCurrentZipcode() {
        currentZipcode
            .flatMap({ (newZip) -> Observable<URL> in
                if let url = try? RxNetworkLayer.getWeatherRequest(forZip: newZip) {
                    return Observable.just(url)
                }
                return Observable.empty()
            })
            .flatMap { [weak self] (url) -> Observable<[HourlyWeather]> in
                print(url)
                if let weather = self?.getForecastFor(url: url) {
                    return weather
                } else {
                    return Observable.empty()
                }
            }
            .subscribe(onNext: { [weak self] (newHourly) in
                self?.totalWeather.onNext(newHourly)
                print("ReceivedNewHourly: \(newHourly.count)")
            })
            .disposed(by: bag)
    }
}

extension RxNetworkLayer {
     func getForecastFor(url: URL) -> Observable<[HourlyWeather]> {
        return requestHourlyForecast(from: url)
            .map { json in
                guard let hourlyForecast  = json["hourly_forecast"] as? [[String: Any]] else {
                    throw NetworkError.hourlyForecastUnavailable
                }
                return hourlyForecast.flatMap(HourlyWeather.init)
        }
    }
    
    func requestHourlyForecast(from url: URL) -> Observable<[String: Any]> {
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { (response, data) -> [String: Any] in
                do {
                    guard
                        let json = try? JSONSerialization.jsonObject(with: data, options: []),
                        let dictionary = json as? [String: Any]
                        else {
                            throw NetworkError.invalidJSONResponse
                    }
                    return dictionary
                }
        }
    }
}

enum NetworkError: Error {
    case hourlyForecastUnavailable
    case currentWeatherUnavailable
    case invalidJSONResponse
    case invalidURL
}
