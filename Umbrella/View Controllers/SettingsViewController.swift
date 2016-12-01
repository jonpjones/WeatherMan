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
    
    
    @IBOutlet weak var getWeatherButton: UIButton!
    @IBOutlet weak var temperatureSegmentedControl: UISegmentedControl!
    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatureSegmentedControl.selectedSegmentIndex = currentSettings.fahrenheight ? 0 : 1
        addVibrancy(view: temperatureSegmentedControl)
        addVibrancy(view: getWeatherButton)
        
    }
    
    func addVibrancy(view: UIView) {
        let vibrancyView = UIVisualEffectView.init(frame: view.bounds)
        vibrancyView.effect = UIVibrancyEffect()
        view.addSubview(vibrancyView)
        view.clipsToBounds = true
        view.tintColor = UIColor(0x03A9F4)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        currentSettings.fahrenheight = sender.selectedSegmentIndex == 0
        delegate?.preferredTemperatureStyleChanged()
    }
    @IBAction func getTheWeatherButtonTapped(_ sender: UIButton) {
        
    }
}

