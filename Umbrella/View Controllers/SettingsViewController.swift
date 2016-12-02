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
    
    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    @IBOutlet weak var getWeatherButton: UIButton!
    @IBOutlet weak var temperatureSegmentedControl: UISegmentedControl!
    @IBOutlet weak var zipTextField: UITextField!
    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatureSegmentedControl.selectedSegmentIndex = currentSettings.fahrenheight ? 0 : 1
        addVibrancy(view: temperatureSegmentedControl)
        addVibrancy(view: getWeatherButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bgView = UIView(frame: view.frame)
        bgView.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmissTap(_:)))
        view.insertSubview(bgView, aboveSubview: backgroundBlurView)
        bgView.addGestureRecognizer(tapGesture)
    }
    
    func dissmissTap(_: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func addVibrancy(view: UIView) {
        let vibrancyView = UIVisualEffectView.init(frame: view.bounds)
        vibrancyView.effect = UIVibrancyEffect.init(blurEffect: UIBlurEffect.init(style: UIBlurEffectStyle.extraLight))
        view.addSubview(vibrancyView)
        view.sendSubview(toBack: vibrancyView)
        view.clipsToBounds = true
        view.tintColor = UIColor(0x03A9F4)
        view.isUserInteractionEnabled = true
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        currentSettings.fahrenheight = sender.selectedSegmentIndex == 0
        delegate?.preferredTemperatureStyleChanged()
        backgroundBlurView.tintColorDidChange()
        sender.layoutIfNeeded()
        sender.tintColorDidChange()
    }
    
    @IBAction func getTheWeatherButtonTapped(_ sender: UIButton) {
        if zipTextField.hasText {
            currentSettings.zip = zipTextField.text!
            var request = WeatherRequest(APIKey: apiKey)
            request.zipCode = currentSettings.zip
            WeatherAPIManager.sharedInstance.fetchHourlyForecast(fromURL: request.URL!, completion: { (success) in
                guard success else {
                    DispatchQueue.main.async {
                        self.presentErrorAlert()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        
    }
}

