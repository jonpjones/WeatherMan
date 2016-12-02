//
//  WeatherRequest.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import Foundation

/**
*  Struct that builds the URL to send to the server for parsing. Call the getter to URL for the fully qualified URL
*/
struct WeatherRequest {
    /// API Key to be used in the application
    private let APIKey: String
    
    /// The zip code to send to the server.
    var zipCode: String?
    
    var URL: Foundation.URL? {
        get {
            /// If there is no zip code, there is no url
            guard let zip = zipCode else {
                return nil
            }
            
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.wunderground.com"
            urlComponents.path = "/api/\(APIKey)/conditions/hourly/q/\(zip).json"
            
            return urlComponents.url
        }
    }
    
    /**
    Initializer
    
    - parameter apiKey: The API Key for weather underground
    
    - returns: The initialized object
    */
    init(APIKey: String) {
        self.APIKey = APIKey
    }
}
