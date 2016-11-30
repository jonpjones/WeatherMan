//
//  CurrentWeather.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/30/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
struct CurrentWeather {
    let fullLocation: String
    let tempC: Int
    let tempF: Int
    let conditions: String
    
    init(withLocation fullLocation: String, tempC: Int, tempF: Int, conditions: String) {
        self.fullLocation = fullLocation
        self.tempC = tempC
        self.tempF = tempF
        self.conditions = conditions
    }
}
