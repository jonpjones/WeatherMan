//
//  SettingsViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func preferredTemperatureStyleChanged()
}

class SettingsViewController: UIViewController {
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
