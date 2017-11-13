//
//  RxNetworkLayer.swift
//  Umbrella
//
//  Created by Jonathan Jones on 10/24/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//
import RxSwift
import RxSwiftExt
import RxCocoa
import Foundation

let apiKey = "833018b6135efd73"

enum HourlySet {
    case today
    case tomorrow
    case other
}

enum NetworkError: Error {
    case hourlyForecastUnavailable
    case currentWeatherUnavailable
    case invalidJSONResponse
    case invalidURL
}

class RxNetworkLayer {
    
    static let shared = RxNetworkLayer(with: "60647")
   
    
    private var weatherResponse = BehaviorSubject<[String: Any]>(value: [:])
    private var bag = DisposeBag()
    private var totalWeather: BehaviorSubject<[HourlyWeather]> = BehaviorSubject(value: [])
    
    public var currentZipcode = PublishSubject<String>()
    open var todaysWeather: Observable<[HourlyWeather]> {
        return self.totalWeather
            .asObservable()
            .map({ [weak self] (allWeather) -> [HourlyWeather] in
                let weather = allWeather.filter { return $0.isToday }
                self?.addTintsTo(weather)
                return weather
            })
    }
    
    open var tomorrowsWeather: Observable<[HourlyWeather]> {
        return self.totalWeather
            .asObservable()
            .map({ [weak self] (allWeather) -> [HourlyWeather] in
                let weather = allWeather.filter { return $0.isTomorrow }
                self?.addTintsTo(weather)
                return weather
            })
    }
    
    open var otherWeather: Observable<[HourlyWeather]> {
        return self.totalWeather
            .asObservable()
            .map({ [weak self] (allWeather) -> [HourlyWeather] in
                let weather = allWeather.filter { return !$0.isToday && !$0.isTomorrow }
                self?.addTintsTo(weather)
                return weather
            })
    }
    
    private init(with zipCode: String) {
        subscribeToCurrentZipcode()
        currentZipcode.onNext(zipCode)
    }
    
    func subscribeToCurrentZipcode() {
        let observableZipURL = currentZipcode.flatMap({ (newZip) -> Observable<URL> in
            if let url = try? RxNetworkLayer.getWeatherRequest(forZip: newZip) {
                return Observable.just(url)
            }
            return Observable.empty()
        })
        
       observableZipURL
            .flatMap { [weak self] (url) -> Observable<[HourlyWeather]> in
                print(url)
                if let weather = self?.getHourlyForecast(url: url) {
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
        
        observableZipURL
            .flatMap { [weak self] (url) -> Observable<[String: Any]> in
                return self?.requestHourlyForecast(from: url) ?? Observable.empty()
            }
            .bind(to: self.weatherResponse).disposed(by: bag)

    }
}

extension RxNetworkLayer {
    func fetchIcon(iconURL: URL) -> Observable<ImageRef?> {
        let request = URLRequest(url: iconURL)
        if let data = URLCache.shared.cachedResponse(for: request)?.data {
            if let image = UIImage(data: data) {
                return Observable.of(ImageRef(image: image, url: iconURL))
            }
        }
        
        return URLSession.shared.rx.data(request: request)
            .do(onNext: { (data) in
                let cache = CachedURLResponse.init(response: URLResponse(), data: data)
                URLCache.shared.storeCachedResponse(cache, for: request)
            })
            .map({ data -> ImageRef? in
                if let image = UIImage(data: data) {
                    return ImageRef(image: image, url: iconURL)
                } else {
                    return nil
                }
            })
    }
    
    func getHourlyForecast(url: URL) -> Observable<[HourlyWeather]> {
        return requestHourlyForecast(from: url)
            .map({ json in
                guard let hourlyForecast  = json["hourly_forecast"] as? [[String: Any]] else {
                    throw NetworkError.hourlyForecastUnavailable
                }
                let hourlyCollection = hourlyForecast.flatMap(HourlyWeather.init)
                self.addTintsTo(hourlyCollection)
                return hourlyCollection
            })
    }
    
    func addTintsTo(_ weather: [HourlyWeather]) {
        let newWeather = weather.sorted { (first, second) -> Bool in
            if let firstTemp = Int(first.tempF), let secondTemp = Int(second.tempF) {
                return (firstTemp == secondTemp) ? (first.timeSince1970 < second.timeSince1970) : (firstTemp > secondTemp)
            } else {
                return true
            }
        }
        newWeather.first?.tintColor = UIColor.maximumOrange
        let minTintHour = newWeather.first(where: { $0.tempF == newWeather.last?.tempF })
        minTintHour?.tintColor = UIColor.minimumBlue
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
    
    static func getWeatherRequest(forZip zipCode: String) throws -> URL {
        guard let weatherRequest = WeatherRequest(APIKey: apiKey, zipCode: zipCode) else {
            throw NetworkError.invalidURL
        }
        return weatherRequest.URL
    }
}
