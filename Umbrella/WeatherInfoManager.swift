//
//  WeatherInfoManager.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/30/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

 protocol WeatherInfoDelegate {
    func received(currentWeather: CurrentWeather)
    func receivedHourlyWeather(todaysWeather: [HourlyWeather]?, tomorrowsWeather: [HourlyWeather]?)
}

let weatherInfo = WeatherInfoManager.sharedInstance
class WeatherInfoManager {
    fileprivate static let sharedInstance = WeatherInfoManager()
    
    var delegate: WeatherInfoDelegate?
    var currentWeather: CurrentWeather? {
        get {
            return self.currentWeather
        }
        set {
            self.delegate?.received(currentWeather: newValue)
        }
    }
    
    var hourlyWeather: [HourlyWeather]?
    
    
}
