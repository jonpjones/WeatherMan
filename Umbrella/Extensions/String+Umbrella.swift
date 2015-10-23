//
//  NSURL+Umbrella.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import Foundation

extension String {
    
    /**
    Returns the URL for the images to be used within the application
    
    - parameter highlighted: If the image is filled in or not
    
    - returns: The URL to be used within the application
    */
    func nrd_weatherIconURL(highlighted highlighted: Bool = false) -> NSURL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "nerdery-umbrella.s3.amazonaws.com"
        
        if highlighted {
            urlComponents.path = "/\(self)-selected.png"
        } else {
            urlComponents.path = "/\(self).png"
        }
        
        return urlComponents.URL
    }
    
}