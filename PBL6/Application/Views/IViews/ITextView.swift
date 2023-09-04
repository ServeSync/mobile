//
//  ITextView.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import UIKit

class ITextView: UITextView {
    
    private var placeholderLabel : UILabel!
    
    @IBInspectable var paddingLeft: CGFloat = 6 {
        didSet {
            textContainerInset = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        }
    }
    @IBInspectable var paddingRight: CGFloat = 6 {
        didSet {
            textContainerInset = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        }
    }
    @IBInspectable var paddingTop: CGFloat = 6 {
        didSet {
            textContainerInset = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        }
    }
    @IBInspectable var paddingBottom: CGFloat = 6 {
        didSet {
            textContainerInset = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        }
    }
    
    var hidePlaceHolder: Bool = false {
        didSet {
            placeholderLabel.isHidden = hidePlaceHolder
        }
    }
    
    private func placeHolder(_ text: String, font: UIFont? = nil) {
        placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.font = font ?? self.font
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (placeholderLabel.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}


