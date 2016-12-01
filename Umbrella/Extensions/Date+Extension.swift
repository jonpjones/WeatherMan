//
//  Date+Extension.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/30/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

extension Date {
    class func today() -> Date {
        
    }
    
    /*
 Returns a date object representing tomorrow's date
 */
    class func tomorrow() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())
    }
    
}
