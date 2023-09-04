//
//  UIView+Animation.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import UIKit

extension UIView {
    func rotate(degrees: CGFloat) {
        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
    
    func scale(scaleX: CGFloat, scaleY: CGFloat) {
        transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    func animToTop(duration: TimeInterval = 0.2, hideBeforeAnim: Bool = false, hideViewAfterAnim: Bool = false, completion: (() -> Void)? = nil){
        isHidden = hideBeforeAnim
        UIView.animate(
            withDuration: duration,
            animations: {
                self.center.y -= self.bounds.height
                if hideViewAfterAnim {
                    self.alpha = 0
                } else {
                    self.alpha = 1
                }
            },  completion: {(_ completed: Bool) -> Void in
                self.isHidden = hideViewAfterAnim
                completion?()
            })
    }
    func animToBottom(duration: TimeInterval = 0.2, hideBeforeAnim: Bool = false, hideViewAfterAnim: Bool = false, completion: (() -> Void)? = nil){
        isHidden = hideBeforeAnim
        UIView.animate(
            withDuration: duration,
            animations: {
                self.center.y += self.bounds.height
                if hideViewAfterAnim {
                    self.alpha = 0
                } else {
                    self.alpha = 1
                }
            },  completion: {(_ completed: Bool) -> Void in
                self.isHidden = hideViewAfterAnim
                completion?()
            })
    }
}

