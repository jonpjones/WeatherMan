//
//  DayHeaderView.swift
//  Umbrella
//
//  Created by Jonathan Jones on 12/1/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import UIKit

class DayHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.backgroundColor = UIColor(0x888888)
    }
}
