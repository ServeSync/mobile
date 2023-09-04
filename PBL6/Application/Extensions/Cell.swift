//
//  Cell.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import UIKit

@IBDesignable extension UITableViewCell {
    
    class var identifier: String { return String.className(self) }
    
    @IBInspectable var selectedColor: UIColor? {
        set {
            let colorView = UIView()
            colorView.backgroundColor = newValue
            self.selectedBackgroundView = colorView
        }
        get {
            return self.selectedBackgroundView?.backgroundColor
        }
    }
    
    open func hideKeyboard() {
        contentView.endEditing(true)
    }
}

extension UICollectionViewCell {
    
    class var identifier: String { return String.className(self) }
    
    @IBInspectable var selectedColor: UIColor? {
        set {
            let colorView = UIView()
            colorView.backgroundColor = newValue
            self.selectedBackgroundView = colorView
        }
        get {
            return self.selectedBackgroundView?.backgroundColor
        }
    }
    
    open func hideKeyboard() {
        contentView.endEditing(true)
    }
}

