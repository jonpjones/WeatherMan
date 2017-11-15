//
//  HourlyWeather.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/30/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import RxDataSources


struct SectionOfHourlyData {
    var header: String
    var items: [HourlyCellViewModel]
}

extension SectionOfHourlyData: SectionModelType {
    typealias Item = HourlyCellViewModel
    
    init(original: SectionOfHourlyData, items: [Item]) {
        self = original
        self.items = items
    }
}

open class HourlyWeather {
    let iconName: String
    let tempC: String
    let tempF: String
    let timeString: String
    let timeSince1970: Double
    var tintColor: UIColor = .black
    var url: URL? {
            return iconName.nrd_weatherIconURL(highlighted: (tintColor == UIColor.minimumBlue ||  tintColor == UIColor.maximumOrange))
    }
    var image: UIImage?
    let isToday: Bool
    let isTomorrow: Bool

    init?(with hour: [String: Any]) {
        let calendar = Calendar(identifier: .gregorian)
        let time = hour["FCTTIME"] as? [String: Any]
        
        guard
            let civilTime = time?["civil"] as? String,
            let epoch = time?["epoch"] as? String,
            let doubleTime = Double(epoch),
            let tempDictionary = hour["temp"] as? [String: String],
            let tempC = tempDictionary["metric"],
            let tempF = tempDictionary["english"]
            else {
                print("Unable to parse dictionary into Hourly Weather")
                return nil
        }
        
        let date = Date(timeIntervalSince1970: doubleTime)
        let isToday = calendar.isDateInToday(date)
        let isTomorrow = calendar.isDateInTomorrow(date)
        let icon = hour["icon"] as! String
        
        self.iconName = icon
        self.tempC = tempC
        self.tempF = tempF
        self.timeString = civilTime
        self.timeSince1970 = doubleTime
        self.isToday = isToday
        self.isTomorrow = isTomorrow
    }
}
