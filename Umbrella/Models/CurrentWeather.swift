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
    
    init?(with json: [String: Any]) {
        guard let currentObservation = json["current_observation"] as? [String: Any] else {
            print("Unable to get current weather information")
            return nil
        }
        
        guard
            let tempF = currentObservation["temp_f"] as? Double,
            let tempC = currentObservation["temp_c"] as? Double,
            let conditions = currentObservation["weather"] as? String
            else {
                print("Unable to get current weather information from response json.")
                return nil
        }
        let locationName = (currentObservation["observation_location"] as? [String: String])?["full"] ?? "Unknown Location"
        self.fullLocation = locationName
        self.tempC = Int(tempC.rounded())
        self.tempF = Int(tempF.rounded())
        self.conditions = conditions
    }
}
