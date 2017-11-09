//
//  File.swift
//  Umbrella
//
//  Created by Jonathan Jones on 6/30/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

class TableViewTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.35
    var sourceRect = CGRect.zero
    var isPresenting = true
    var animator: UIViewPropertyAnimator?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)

        guard
            let sourceView = transitionContext.view(forKey: .from),
            let destinationView = transitionContext.view(forKey: .to)
            else {
                return
        }
      
        let finalFrame = sourceView.frame
        destinationView.frame = finalFrame
        
        let initialScaleX = sourceRect.width / sourceView.frame.width
        let initialScaleY = sourceRect.height / sourceView.frame.height
        
        destinationView.transform = isPresenting ? CGAffineTransform(scaleX: initialScaleX, y: initialScaleY) : .identity
        destinationView.frame.origin = isPresenting ? sourceRect.origin : finalFrame.origin
        destinationView.alpha = isPresenting ? 0.2 : 1.0
        
        isPresenting ? transitionContext.containerView.addSubview(destinationView) : transitionContext.containerView.insertSubview(destinationView, belowSubview: sourceView)
        
        
        CATransaction.completionBlock()
         if isPresenting {
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6, animations: {
                    destinationView.transform = CGAffineTransform(scaleX: 1, y: initialScaleY * 2)
                    destinationView.center = CGPoint(x: transitionContext.containerView.center.x, y: self.sourceRect.midY)//
                })
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4, animations: {
                    destinationView.alpha = 1.0
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
                    destinationView.transform = .identity
                    destinationView.frame.origin = CGPoint.zero
                })
                
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            if let fromVC = transitionContext.viewController(forKey: .from) as? SampleViewController {
                let buttonAnim = BasicAnimation.shrinkAndSpin(view: fromVC.closeButton, direction: .clockWise, duration: duration)
                animator?.add(buttonAnim)
                animator?.startAnimation()
            }
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = duration
            animationGroup.fillMode = kCAFillModeBoth
 
            let xAnimation = CABasicAnimation(keyPath: "position.x")
            xAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.7, 0.3)
            xAnimation.toValue = sourceRect.midX
            
            let yAnimation = CABasicAnimation(keyPath: "position.y")
            yAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.8, 0.6, 1.00)
            yAnimation.toValue = sourceRect.midY
            
            let widthAnimation = CABasicAnimation(keyPath: "bounds.size.width")
            widthAnimation.toValue = sourceRect.width
            widthAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.7, 0.3)
            
            let heightAnimation = CABasicAnimation(keyPath: "bounds.size.height")
            heightAnimation.toValue = sourceRect.height
            heightAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.8, 0.8, 1.00)
            
            animationGroup.animations = [xAnimation, yAnimation, widthAnimation, heightAnimation]
            sourceView.layer.add(animationGroup, forKey: nil)
            
            UIView.animate(withDuration: duration, animations: {
                sourceView.alpha = 0.0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
