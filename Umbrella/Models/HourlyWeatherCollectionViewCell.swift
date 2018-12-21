//
//  HourlyWeatherCollectionViewCell.swift
//  Umbrella
//
//  Created by Jonathan Jones on 12/1/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    var animator: UIViewPropertyAnimator?
    var tint: UInt?
    var expanded: Bool?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        let tintColor = tint != nil ? UIColor(tint!) : .black
        timeLabel.textColor = tintColor
        iconImageView.tintColor = tintColor
        tempLabel.textColor = tintColor
    }
}
