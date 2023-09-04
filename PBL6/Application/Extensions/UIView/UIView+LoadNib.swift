//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import Foundation
import UIKit

extension UIView {
    class func instanceFromNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func instanceFromNib() -> Self {
        return instanceFromNib(self)
    }
}
