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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        fatalError("Look at me first")
        // All the layout metrics are contained in the file called metrics.md located as a descendant of the Supporting Files group
        // Reference screen shots are contained in the reference images folder located as a descendant of the Umbrella group
        
        // Our designer didn't use the actual degree symbol, but used the "ring above" symbol (option+K) ˚ instead
        // because he thought it looks better. You can use either ring above or the actual degree symbol (option-shift-8) °.
        // Throw a comment if you want on which you chose and why.
        
        // UIColors for the use for reference in the rest of the application
        let warmColor = UIColor(0xFF9800)
        let coolColor = UIColor(0x03A9F4)
        
        // Setup the request
        var weatherRequest = WeatherRequest(APIKey: "YOUR API KEY")
        
        // Set the zip code
        weatherRequest.zipCode = "90210"
        
        // Here's your URL. Marshall this to the internet however you please.
        let url = weatherRequest.URL
        
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
        let solidIcon = "clear".nrd_weatherIconURL(highlighted: true)
        let outlineIcon = "clear".nrd_weatherIconURL()
        
        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

}

