//
//  AppDelegate.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // All the layout metrics are contained in the file called metrics.md located as a sibling of the AppDelegate.swift.
        // Reference screen shots are contained in the reference images folder located as a descendant of the Umbrella group
        
        // Our designer didn't use the actual degree symbol, but used the "ring above" symbol (option+K) ˚ instead
        // because he thought it looks better. You can use either ring above or the actual degree symbol (option-shift-8) °.
        // Throw a comment if you want on which you chose and why.
        
        // UIColors for the use for reference in the rest of the application
        
        
               // Here’s where to look for the information, because let’s be honest, you know how to read JSON
        // All values are as of October 13, 2015
        
        // Current Conditions
        // City         : current_observation.display_location.full
        // Temp         : current_observation.(temp_f || temp_c)
        // Condition    : current_observation.weather
        
        // Hourly information
        // Timestamp    : hourly_forecast.FCTTIME.(civil = string representation, epoch = date from 1970)
        // Icon         : hourly_forecast.icon
        // Temp         : hourly_forecast.temp.(english || metric)
        
        // How to use the icon name to get the URL. Solid icons are used for the daily highs and lows
               
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        var request = WeatherRequest(APIKey: apiKey)
        request.zipCode = CurrentSettings.sharedInstance.zip
        WeatherAPIManager.sharedInstance.fetchHourlyForecast(fromURL: request.URL!) { (success) in
            
        }
    }
}

