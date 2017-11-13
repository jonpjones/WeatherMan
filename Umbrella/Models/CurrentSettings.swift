//
//  CurrentSettings.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/30/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import RxSwift

enum TempMode: Int {
    case fahrenheight = 0
    case celcius = 1
}

class CurrentSettings {
    static let sharedInstance = CurrentSettings()
    private init() {}
    var zip: String = "60647"
    var tempStyle: BehaviorSubject<TempMode> = BehaviorSubject<TempMode>(value: .fahrenheight)
}
