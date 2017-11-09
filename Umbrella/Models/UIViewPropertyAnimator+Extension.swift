//
//  UIViewPropertyAnimator+Extension.swift
//  Umbrella
//
//  Created by Jonathan Jones on 6/28/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

extension UIViewPropertyAnimator {
    func add(_ animation: BasicAnimation) {
        addAnimations(animation.animation())
    }
}
