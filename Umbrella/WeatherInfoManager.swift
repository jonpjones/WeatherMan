//
//  WeatherInfoManager.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/30/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

let weatherInfo = WeatherInfoManager.sharedInstance
class WeatherInfoManager {
    fileprivate static let sharedInstance = WeatherInfoManager()
    var todayWeather: [HourlyWeather]?
    var tomorrowWeather: [HourlyWeather]?
    
}
