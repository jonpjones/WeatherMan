//
//  HourlyCellViewModel.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/10/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//

import Foundation
import RxSwift

struct Temperature {
    let farenheight: String
    let celcius: String
}

class HourlyCellViewModel {
    private var disposeBag = DisposeBag()
    
    var icon: BehaviorSubject<UIImage?>
    var time: BehaviorSubject<String>
    var temperature: BehaviorSubject<Temperature>
    var tint: BehaviorSubject<UIColor>
    
    let weather: HourlyWeather
    
    init(with weather: HourlyWeather) {
        self.weather = weather
        self.icon = BehaviorSubject<UIImage?>(value: nil)
        self.time = BehaviorSubject<String>(value: weather.timeString)
        self.tint = BehaviorSubject<UIColor>(value: weather.tintColor)
        self.temperature = BehaviorSubject<Temperature>(value: Temperature(farenheight: weather.tempF, celcius: weather.tempC))
        subscribeToIconRequest()
    }
    
    func subscribeToIconRequest() {
        ImageCache.shared.imageSubject
            .filter { [weak self] (imageRef) -> Bool in
                if let cellIconURL = self?.weather.url {
                    return imageRef.0 == cellIconURL
                } else {
                    return false
                }
            }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (url, image) in
                self?.weather.image = image
                self?.icon.onNext(image)
            })
            .disposed(by: disposeBag)
    }
}
