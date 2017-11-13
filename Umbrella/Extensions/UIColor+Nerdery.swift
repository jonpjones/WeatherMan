//
//  UIColor+Nerdery.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

extension UIColor {
    /**
    Simple method to go from human readable form to a UIColor.

    - parameter rgbHex: hexValue to use. For example, green would be UIColor(0x00FF00)
    - parameter alpha:  The opacity value of the color object, specified as a value from 0.0 to 1.0.
    
    - returns: An initialized color object. The color information represented by this object is in the device RGB colorspace.
    */
    public convenience init (_ rgbHex: UInt,  alpha: CGFloat = 1.0) {
        let rawRed = Double((rgbHex >> 16) & 0xFF) / 255.0
        let rawGreen = Double((rgbHex >> 8) & 0xFF) / 255.0
        let rawBlue = Double(rgbHex & 0xFF) / 255.0
        self.init(red: CGFloat(rawRed), green: CGFloat(rawGreen), blue: CGFloat(rawBlue), alpha: alpha)
    }
    
    static var minimumBlue: UIColor { return UIColor(0x03A9F4) }
    static var maximumOrange: UIColor { return UIColor(0xFF9800) }
}


