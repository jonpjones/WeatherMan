//
//  HourlyWeather.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/30/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

class HourlyWeather {
    let iconName: String
    let tempC: String
    let tempF: String
    let timeString: String
    let timeSince1970: Double
    var tintColor: UInt?
    let isToday: Bool
    let isTomorrow: Bool
    
    init(iconName: String, tempC: String, tempF: String, timeString: String, timeSince1970: Double, isToday: Bool, isTomorrow: Bool) {
        self.iconName = iconName
        self.tempC = tempC
        self.tempF = tempF
        self.timeString = timeString
        self.timeSince1970 = timeSince1970
        self.isToday = isToday
        self.isTomorrow = isTomorrow
    }
}
