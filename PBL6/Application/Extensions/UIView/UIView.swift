//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import UIKit

extension UIView {
    
    func removeAllSubviews() {
        subviews.forEach({subview in
            subview.removeFromSuperview()
        })
    }
    
    func createBlurEffect(style: UIBlurEffect.Style,
                          backgroundColor: UIColor = UIColor(hex: 0xffffff, alpha: 0.2),
                          cornerRadius: CGFloat = 0) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.backgroundColor = backgroundColor
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.cornerRadius = cornerRadius
        return blurEffectView
    }
    
    func asImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
    
}

