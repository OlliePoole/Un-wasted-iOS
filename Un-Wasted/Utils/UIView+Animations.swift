//
//  UIView+Animations.swift
//  Un-Wasted
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit

extension UIView {
    
    enum ShakeAnimationMagnitude {
        case small
        case medium
    }
    
    func animateAlpha(to value: CGFloat, duration: TimeInterval = 0.3) {
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = value
            
            if value == 0.0 {
                self.isHidden = true
            }
            else {
                self.isHidden = false
            }
            
        }) { _ in
            if self.alpha == 0.0 {
                self.isHidden = true
            }
        }
    }
    
    func shake(magnitude: ShakeAnimationMagnitude) {
        switch magnitude {
        case .small:
            shake(values: [-5, 5, -5, 5, -3, 3, -1, 1, 0.0])
            
        case .medium:
            shake(values: [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0])
        }
    }
    
    private func shake(values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = values
        layer.add(animation, forKey: "shake")
    }
}
