//
//  CurrentSettings.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/30/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

let currentSettings = CurrentSettings.sharedInstance
class CurrentSettings {
    static let sharedInstance = CurrentSettings()
    var zip: String = "60647"
    var fahrenheight: Bool = true
}
