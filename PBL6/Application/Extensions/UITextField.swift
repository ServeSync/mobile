//
//  UITextField.swift
//  PBL6
//
//  Created by KietKoy on 16/09/2023.
//

import UIKit

extension UITextField {
    func setLeftIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 16, y: 5, width: 24, height: 24))
        iconView.image = image
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor)
        ])
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setRightIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 16, y: 5, width: 24, height: 24))
        iconView.image = image
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor)
        ])
        rightView = iconContainerView
        rightViewMode = .always
    }
}
