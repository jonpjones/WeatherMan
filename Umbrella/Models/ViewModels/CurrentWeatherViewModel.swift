//
//  CurrentWeatherViewModel.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/10/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//

import Foundation
import RxSwift

class CurrentWeatherViewModel {
    let fullLocation: BehaviorSubject<String>
    let temp: BehaviorSubject<String>
    let conditions: BehaviorSubject<String>
    let backgroundColor: BehaviorSubject<UIColor>
    
    private var currentWeather: CurrentWeather
    let disposeBag = DisposeBag()
    init(with weather: CurrentWeather) {
        let tempMode = try? CurrentSettings.sharedInstance.tempStyle.value()
        self.currentWeather = weather
        
        let tempString = tempMode == .fahrenheight ? "\(weather.tempF)" : "\(weather.tempC)"
        
        self.fullLocation = BehaviorSubject<String>(value: weather.fullLocation)
        self.temp = BehaviorSubject<String>(value: tempString)
        self.conditions = BehaviorSubject<String>(value: weather.conditions)
        self.backgroundColor = BehaviorSubject<UIColor>(value: weather.tempF > 70 ? .maximumOrange : .minimumBlue)
        subscribeToChangingSettings()
    }
    
    func subscribeToChangingSettings() {
        CurrentSettings.sharedInstance
            .tempStyle
            .subscribe(onNext: { [weak self] newStyle in
                if let tempF = self?.currentWeather.tempF, let tempC = self?.currentWeather.tempC {
                    let tempString = (newStyle == .fahrenheight) ? "\(tempF)" : "\(tempC)"
                    self?.temp.onNext(tempString)
                }
            })
            .disposed(by: disposeBag)
    }
}
