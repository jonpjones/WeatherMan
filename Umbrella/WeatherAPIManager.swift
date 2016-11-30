//
//  WeatherAPIManager.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/28/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

class WeatherAPIManager {
    static let sharedInstance = WeatherAPIManager()
    
    func fetchHourlyForecast(fromURL: URL) {
        
        
        URLSession.shared.dataTask(with: fromURL) { (data, response, error) in
            
            guard error == nil else { print(error); return }
            do {
                let weatherJSON = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
                guard let currentObservation = weatherJSON?["current_observation"] as? [String: Any] else { return }
                let locationName = (currentObservation["current_observation"] as? [String: String])?["full"] ?? "Anytown"
                
                let tempF = currentObservation["temp_f"] as? Double
                let tempC = currentObservation["temp_c"] as? Double
                
                
                guard let hourlyForecast = weatherJSON?["hourly_forecast"] as? [Any] else {return}
                
                
                
                print("testt")
                
                
                
                
                // Current Conditions
                // City         : current_observation.display_location.full
                // Temp         : current_observation.(temp_f || temp_c)
                // Condition    : current_observation.weather
                
                // Hourly information
                // Timestamp    : hourly_forecast.FCTTIME.(civil = string representation, epoch = date from 1970)
                // Icon         : hourly_forecast.icon
                // Temp         : hourly_forecast.temp.(english || metric)

            } catch {
                print("Not convertable")
            }
            
        }.resume()
        
    }
    
    
}
