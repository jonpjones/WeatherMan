//
//  HourlyWeatherCollectionViewCell.swift
//  Umbrella
//
//  Created by Jonathan Jones on 12/1/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import UIKit
import RxSwift

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var temperature: Temperature?
    var hourlyViewModel: HourlyCellViewModel? {
        didSet {
    
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            if let viewModel = hourlyViewModel {
                viewModel.icon
                    .bind(to: iconImageView.rx.image)
                    .disposed(by: disposeBag)
                viewModel.time
                    .bind(to: timeLabel.rx.text)
                    .disposed(by: disposeBag)
               
                viewModel.tint
                    .asObservable()
                    .subscribe(onNext: { [weak self] newTint in
                        self?.iconImageView.tintColor = newTint
                        self?.timeLabel.textColor = newTint
                        self?.tempLabel.textColor = newTint
                    })
                    .disposed(by: disposeBag)
                
                Observable
                    .combineLatest(viewModel.temperature, CurrentSettings.sharedInstance.tempStyle) { return ($0, $1) }
                    .subscribe(onNext: { [weak self] (temp, style) in
                        switch style {
                        case .celcius:
                            self?.tempLabel.text = temp.celcius
                        case .fahrenheight:
                            self?.tempLabel.text = temp.farenheight
                        }
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
    
    var animator: UIViewPropertyAnimator?
    var tint: UIColor?
    var expanded: Bool?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }
}
