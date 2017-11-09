//
//  AnimationFactory.swift
//  Umbrella
//
//  Created by Jonathan Jones on 6/27/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//

import UIKit
enum BasicAnimation {
    enum Axis {
        case x
        case y
    }
    enum RotationDirection: CGFloat {
        case clockWise = 1
        case counterClockwise = -1
    }
    case spin(view: UIView)
    case move(view: UIView, axis: Axis, distance: CGFloat)
    case shrinkAndSpin(view: UIView, direction: RotationDirection, duration: Double)
    case bounceScale(view: UIView)
    case blueView(_: UIVisualEffectView, shouldBlur: Bool)
    
    func animation() -> (() -> Void) {
        switch self {
        case .blueView(let blurView, let shouldBlur):
            return {
                blurView.effect = shouldBlur ? UIBlurEffect(style: .dark) : nil
            }
        case .spin(let view):
            return {
               UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: { 
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                    view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5, animations: { 
                    view.transform = CGAffineTransform(rotationAngle: -.pi)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: { 
                    view.transform = CGAffineTransform(rotationAngle: -3/2 * .pi)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: { 
                    view.transform = .identity
                })
               }, completion: nil)
            }
        case .move(let view, let axis, let distance):
            return {
                
            }
            
        case .bounceScale(let view):
            return {
                UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {

                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                        view.transform = CGAffineTransform(translationX: 0, y: -5).concatenating(CGAffineTransform(scaleX: 0.1, y: 0.1))
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                        view.transform = .identity
                    })
                
                }, completion: nil)
            }
            
        case .shrinkAndSpin(let view, let direction, let duration):
            return {
                let rotationDirection = direction.rawValue
                
                let animGroup = CAAnimationGroup()
                animGroup.duration = duration
                
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotationAnimation.toValue = rotationDirection * .pi / 2
                
                let shrinkAnimation = CABasicAnimation(keyPath: "transform.scale")
                shrinkAnimation.toValue = 0.1
                
                animGroup.animations = [rotationAnimation, shrinkAnimation]
                view.layer.add(animGroup, forKey: nil)
            }

        }
    }
}

