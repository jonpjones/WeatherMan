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
    
    func jiggle() {
        if animator == nil {
            animator = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.1)
            animator?.isInterruptible = true
            animator?.add(.bounceScale(view: self.contentView))
            animator?.add(.spin(view: self.iconImageView))
            animator?.addCompletion({ (position) in
                self.animator = nil
            })
           
        }
        else if animator?.isRunning == true {
            animator?.pauseAnimation()
            animator?.isReversed = true
            
        }
        animator?.startAnimation()
        
    }
    
    func pop() {
        if let expanded = expanded {
            self.expanded = !expanded
        } else {
            expanded = true
        }
        
        if expanded ?? true {
            let animationGroup = CAAnimationGroup()
            
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.0
            pulse.toValue = 1.1
            pulse.damping = 50
            pulse.stiffness = 70
            pulse.autoreverses = true
            pulse.initialVelocity = -10
            
            let opacityAnim = CABasicAnimation(keyPath: "opacity")
            opacityAnim.fromValue = 1.0
            opacityAnim.toValue = 0.8
            
            animationGroup.autoreverses = true
            animationGroup.repeatCount = 0
            animationGroup.duration = 0.8
            
            animationGroup.isRemovedOnCompletion = true
            animationGroup.animations = [opacityAnim, pulse]
            
            self.layer.add(animationGroup, forKey: "pop")
            
        } else {
            
            let unpopAnimGroup = CAAnimationGroup()
            let cornerAnim = CABasicAnimation(keyPath: "cornerRadius")
            cornerAnim.fromValue = layer.presentation()?.cornerRadius
            cornerAnim.toValue = 0.0
            
            let scale = CABasicAnimation(keyPath: "transform.scale")
            scale.fromValue = layer.presentation()?.contentsScale
            scale.toValue = 1.0
            
            let bgColorAnim = CABasicAnimation(keyPath: "backgroundColor")
            bgColorAnim.toValue = UIColor.white.cgColor
            
            unpopAnimGroup.duration = 2
            unpopAnimGroup.animations = [cornerAnim, scale, bgColorAnim]
            
            self.layer.add(unpopAnimGroup, forKey: "pop")
            
            UIView.animate(withDuration: unpopAnimGroup.duration, animations: {
                let tintColor = self.tint != nil ? UIColor(self.tint!) : .black
                self.timeLabel.textColor = tintColor
                self.iconImageView.tintColor = tintColor
                self.tempLabel.textColor = tintColor
            })
            
        }
    }
}
