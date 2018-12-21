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
    func nrd_weatherIconURL(highlighted: Bool = false) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "codechallenge.nerderylabs.com"
        
        if highlighted {
            urlComponents.path = "/mobile-nat/\(self)-selected.png"
        } else {
            urlComponents.path = "/mobile-nat/\(self).png"
        }
        
        return urlComponents.url
    }
    
}
