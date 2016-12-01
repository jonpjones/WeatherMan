//
//  WeatherInfoManager.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/30/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherInfoDelegate {
    func received(currentWeather: CurrentWeather)
    func receivedHourlyWeather(forDays: [[HourlyWeather]])
    func receivedIcon(name: String, solid: Bool)
}


let weatherInfo = WeatherInfoManager.sharedInstance
class WeatherInfoManager {
    fileprivate static let sharedInstance = WeatherInfoManager()
    var outlineIconNameSet: Set<String> = []
    var solidIconNameSet: Set<String> = []
    var weatherIconDictionary: [String: [String:UIImage]] = [:]

    var delegate: WeatherInfoDelegate?
    
    private var currentWeatherPrivate: CurrentWeather?
    var currentWeather: CurrentWeather? {
        get {
            return currentWeatherPrivate
        }
        set {
            currentWeatherPrivate = newValue!
            self.delegate?.received(currentWeather: newValue!)
        }
    }
    
    var hourlyWeather: [HourlyWeather]? {
        get {
            return self.hourlyWeather
        }
        set {
            var todayHourlyArray: [HourlyWeather] = []
            var tomorrowHourlyArray: [HourlyWeather] = []
            var twoDaysHenceHourlyArray: [HourlyWeather] = []
            for hour in newValue! {
                hour.isToday ? todayHourlyArray.append(hour) : hour.isTomorrow ? tomorrowHourlyArray.append(hour) : twoDaysHenceHourlyArray.append(hour)
            }
            
            let todayHourlySorted = addTintColorsToMaxAndMin(hourly: todayHourlyArray)
            let tomorrowHourlySorted = addTintColorsToMaxAndMin(hourly: tomorrowHourlyArray)
            let twoDaysHourlySorted = addTintColorsToMaxAndMin(hourly: twoDaysHenceHourlyArray)
            
            getIconsFromNerdery()
            delegate?.receivedHourlyWeather(forDays: [todayHourlySorted, tomorrowHourlySorted, twoDaysHourlySorted])
        }
    }
    
    func addTintColorsToMaxAndMin(hourly: [HourlyWeather]) -> [HourlyWeather] {
        var hourlySorted = hourly.sorted {
            return $0.tempF < $1.tempF
        }
        
        if hourlySorted.count > 1 && hourlySorted.last?.tempF != hourlySorted.first?.tempF {
            
            let maxTemp = hourlySorted.last!.tempF
            let minTemp = hourlySorted.first!.tempF
            
            hourlySorted.sort {
                return $0.timeSince1970 < $1.timeSince1970
            }

            let maxHour = hourlySorted.first(where: { (hour) -> Bool in
                return hour.tempF == maxTemp
            })
            maxHour?.tintColor = 0xFF9800
            solidIconNameSet.insert(maxHour!.iconName)
            
            let minHour = hourlySorted.first(where: { (hour) -> Bool in
                return hour.tempF == minTemp
            })
            minHour?.tintColor = 0x03A9F4
            solidIconNameSet.insert(minHour!.iconName)
            
            hourlySorted.forEach({ (hour) in
                if hour.tintColor == nil {
                    outlineIconNameSet.insert(hour.iconName)
                }
            })
        }
        
        hourlySorted.sort {
            return $0.timeSince1970 < $1.timeSince1970
        }
        return hourlySorted
    }
    
    func getIconsFromNerdery() {
        for icon in solidIconNameSet {
            WeatherAPIManager.sharedInstance.fetchIcon(name: icon, solid: true)
        }
        for icon in outlineIconNameSet {
            WeatherAPIManager.sharedInstance.fetchIcon(name: icon, solid: false)
        }
    }
}

//MARK: - WeatherAPIManagerDelegate
extension WeatherInfoManager: WeatherAPIManagerDelegate {
    func receivedIconInfo(name: String, solid: Bool) {
        delegate?.receivedIcon(name: name, solid: solid)
    }
}
