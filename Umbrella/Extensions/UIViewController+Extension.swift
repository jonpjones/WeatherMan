//
//  UIViewController+Extension.swift
//  Umbrella
//
//  Created by Jonathan Jones on 12/1/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentErrorAlert() {
        let alert = UIAlertController(title: "Oops!", message: "Something went wrong. Please enter a valid zipcode to get weather info.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            if ((self as? SettingsViewController) != nil) {
                return
            } else if (self as? MainViewController) != nil {
                (self as! MainViewController).popOverToSettings(source: self.view)
            } else {
                return
            }
        }
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
    }
    
}
