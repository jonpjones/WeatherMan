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
    func receivedHourlyWeather(todaysWeather: [HourlyWeather]?, tomorrowsWeather: [HourlyWeather]?, twoDaysOut: [HourlyWeather]?)
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
            
            
           todayHourlyArray.sort {
                return $0.tempF < $1.tempF
            }
            
            if todayHourlyArray.count > 1 {
                let count = todayHourlyArray.count
                if todayHourlyArray.last!.tempF != todayHourlyArray[count - 2].tempF {
                    todayHourlyArray[count - 1].tintColor = 0xFF9800
                }
                
                if todayHourlyArray.first!.tempF != todayHourlyArray[1].tempF {
                    todayHourlyArray[0].tintColor = 0x03A9F4
                }
            }
            
            todayHourlyArray.sort {
                return $0.timeSince1970 < $1.timeSince1970
            }
            
            tomorrowHourlyArray.sort {
                return $0.timeSince1970 < $1.timeSince1970
            }
            
            print(tomorrowHourlyArray)
        }
    }
    
    func addTintColorsToMaxAndMin(hourly: [HourlyWeather]) -> [HourlyWeather] {
        
    }
    
    
}
