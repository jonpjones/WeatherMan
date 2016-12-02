//
//  UIVisualEffectView+Extension.swift
//  Umbrella
//
//  Created by Jonathan Jones on 12/1/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import UIKit
extension UIVisualEffectView {
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self.contentView ? nil : view
    }
}
