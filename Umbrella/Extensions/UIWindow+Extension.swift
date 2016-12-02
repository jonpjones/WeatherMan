//
//  UIWindow+Extension.swift
//  Umbrella
//
//  Created by Jonathan Jones on 12/1/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    func visibleViewController() -> UIViewController? {
        if isKeyWindow {
            var root = rootViewController
            while let presentedVC = root?.presentedViewController {
                root = presentedVC
            }
            return root
        }
        return nil
    }
}
