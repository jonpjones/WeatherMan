//
//  CurrentWeatherview.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/13/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CurrentWeatherview: UIView {
    
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var currentConditionsLabel: UILabel!
    @IBOutlet var settingsButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var settingsTapped: ControlEvent<()>?
    
    var currentWeatherViewModel: CurrentWeatherViewModel? {
        didSet {
            if let viewModel = currentWeatherViewModel {
                viewModel.conditions
                    .bind(to: currentConditionsLabel.rx.text)
                    .disposed(by: disposeBag)
                viewModel.fullLocation
                    .bind(to: currentLocationLabel.rx.text)
                    .disposed(by: disposeBag)
                viewModel.temp
                    .bind(to: currentTempLabel.rx.text)
                    .disposed(by: disposeBag)
                viewModel.backgroundColor
                    .subscribe(onNext: { [weak self] newColor in
                        self?.backgroundColor = newColor
                    })
                    .disposed(by: disposeBag)
            }
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        if let nib = Bundle.main.loadNibNamed("CurrentWeatherView", owner: self, options: nil), let subView = nib[0] as? UIView {
            self.addSubview(subView)
            self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            subView.translatesAutoresizingMaskIntoConstraints = false
            subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            subView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            subView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            
        }
        
        let events = settingsButton.rx.controlEvent(UIControlEvents.touchUpInside)
        self.settingsTapped = events
    }
}
