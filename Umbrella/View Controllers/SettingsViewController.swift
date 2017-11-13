//
//  SettingsViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SettingsViewControllerDelegate {
    func preferredTemperatureStyleChanged()
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    @IBOutlet weak var getWeatherButton: UIButton!
    @IBOutlet weak var temperatureSegmentedControl: UISegmentedControl!
    @IBOutlet weak var zipTextField: UITextField!
    
    var delegate: SettingsViewControllerDelegate?
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zipTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.zipTextField.text }
            .filter { (text) -> Bool in
                let zipCodeRegex =  "^[0-9]{5}(-[0-9]{4})?$"
                let zipCodePredicate = NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
                return zipCodePredicate.evaluate(with: text)
            }
            .subscribe(onNext: { text in
                if let zipText = text {
                    print("new zip code")
                    RxNetworkLayer.shared.currentZipcode.onNext(zipText)
                }
            })
            .disposed(by: disposeBag)
        
        CurrentSettings.sharedInstance
            .tempStyle
            .asObservable()
            .take(1)
            .subscribe(onNext: { tempStyle in
                self.temperatureSegmentedControl.selectedSegmentIndex = tempStyle.rawValue
            })
            .disposed(by: disposeBag)
        
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
    
    @objc func dissmissTap(_: UITapGestureRecognizer) {
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
        
        let tempStyle: TempMode = (sender.selectedSegmentIndex == 0) ? .fahrenheight : .celcius
        CurrentSettings.sharedInstance.tempStyle.onNext(tempStyle)
        
        delegate?.preferredTemperatureStyleChanged()
        backgroundBlurView.tintColorDidChange()
        sender.layoutIfNeeded()
        sender.tintColorDidChange()
    }
    
//    @IBAction func getTheWeatherButtonTapped(_ sender: UIButton) {
//        if zipTextField.hasText {
//            currentSettings.zip = zipTextField.text!
//            var request = WeatherRequest(APIKey: apiKey, zipCode: currentSettings.zip)
//            WeatherAPIManager.sharedInstance.fetchHourlyForecast(fromURL: request!.URL, completion: { (success) in
//                guard success else {
//                    DispatchQueue.main.async {
//                        self.presentErrorAlert()
//                    }
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.presentingViewController?.dismiss(animated: true, completion: nil)
//                }
//            })
//        }
//    }
}

