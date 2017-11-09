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
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        var request = WeatherRequest(APIKey: apiKey)
        request.zipCode = CurrentSettings.sharedInstance.zip
        WeatherAPIManager.sharedInstance.fetchHourlyForecast(fromURL: request.URL!) { (success) in
            guard success else {
                let window = UIApplication.shared.keyWindow
                let presentedVC = window?.visibleViewController()
                presentedVC?.presentErrorAlert()
                return
            }
        }
    }
}

