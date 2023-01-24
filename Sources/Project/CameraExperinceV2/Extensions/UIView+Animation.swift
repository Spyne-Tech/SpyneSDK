//
//  UIView+Animationm.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 28/11/22.
//

import UIKit

//MARK: - UIView Extension for the View animations
extension UIView {
    /// fadeIn: method is used to animate the View for Fade in
    func fadeIn(_ duration: TimeInterval = 0.15, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
    }, completion: completion)  }

    /// fadeOut: method is used to animate the View for Fade out
    func fadeOut(_ duration: TimeInterval = 0.15, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
    }, completion: completion)
   }
}
