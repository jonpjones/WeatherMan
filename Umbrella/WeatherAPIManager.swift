//
//  WeatherAPIManager.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/28/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherAPIManagerDelegate {
    func receivedIconInfo(name: String, state: String)
}
class WeatherAPIManager {
    static let sharedInstance = WeatherAPIManager()
    var delegate: WeatherAPIManagerDelegate = weatherInfo
    
    func fetchHourlyForecast(fromURL: URL) {
        URLSession.shared.dataTask(with: fromURL) { (data, response, error) in
            
            guard error == nil else { print(error); return }
            do {
                let weatherJSON = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
                guard let currentObservation = weatherJSON?["current_observation"] as? [String: Any] else { return }
                let locationName = (currentObservation["observation_location"] as? [String: String])?["full"] ?? "Unknown Location"
                
                let tempF = currentObservation["temp_f"] as! Double
                let tempC = currentObservation["temp_c"] as! Double
                let conditions = currentObservation["weather"] as! String
                
                let currentWeather = CurrentWeather(withLocation: locationName, tempC: Int(tempC.rounded()), tempF: Int(tempF.rounded()), conditions: conditions)
                
                guard let hourlyForecast = weatherJSON?["hourly_forecast"] as? [[String: Any]] else {return}
                
                let calendar = Calendar(identifier: .gregorian)

                var hourlyWeatherArray: [HourlyWeather] = []
                
                for hour in hourlyForecast {
                    let time = hour["FCTTIME"] as? [String: Any]
                    
                    guard let civilTime = time?["civil"] as? String else { return }
                    guard let epoch = time?["epoch"] as? String else { return }
                    
                    let date = Date(timeIntervalSince1970: Double(epoch)!)
                    let isToday = calendar.isDateInToday(date)
                    let isTomorrow = calendar.isDateInTomorrow(date)
                    let tempC = (hour["temp"] as! [String: String])["metric"]!
                    let tempF = (hour["temp"] as! [String: String])["english"]!
                    let icon = hour["icon"] as! String

                    let hourlyWeather = HourlyWeather(iconName: icon, tempC: tempC, tempF: tempF, timeString: civilTime, timeSince1970: Double(epoch)!, isToday: isToday, isTomorrow: isTomorrow)
                    
                    hourlyWeatherArray.append(hourlyWeather)
                }
                
                DispatchQueue.main.async {
                    weatherInfo.currentWeather = currentWeather
                    weatherInfo.hourlyWeather = hourlyWeatherArray
                }
            } catch {
                print("Not convertable")
            }
        }.resume()
    }
    
    func fetchIcon(name: String, solid: Bool) {
        let iconURL = name.nrd_weatherIconURL(highlighted: solid)
        
        URLSession.shared.dataTask(with: iconURL!) { (data, response, error) in
            guard error == nil else { return }
            if let image = UIImage(data: data!) {
                DispatchQueue.main.async {
                    var iconDictionary = weatherInfo.weatherIconDictionary?[name]
                    let iconState = solid ? "solid" : "outline"
                    iconDictionary?[iconState] = image
                    self.delegate.receivedIconInfo(name: name, state: iconState)
                }
            }
        }.resume()
    }
}
