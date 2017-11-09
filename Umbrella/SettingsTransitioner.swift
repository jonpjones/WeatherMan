//
//  SettingsTransitioner.swift
//  Umbrella
//
//  Created by Jonathan Jones on 7/5/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

class SettingsTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.35
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
