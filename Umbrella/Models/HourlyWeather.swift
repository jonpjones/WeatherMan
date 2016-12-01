//
//  HourlyWeather.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/30/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

struct HourlyWeather {
    let iconName: String
    let tempC: String
    let tempF: String
    let timeString: String
    let timeSince1970: Double
    var tintColor: UInt?
    let isToday: Bool
    let isTomorrow: Bool
}
