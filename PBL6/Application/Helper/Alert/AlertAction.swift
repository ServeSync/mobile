//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import UIKit

class AlertAction {
    var title: String = ""
    var style: AlertActionStyle = .normal
    var onClick: ((String) -> Void)? = nil
    
    init(title: String, style: AlertActionStyle, onClick: ((String) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.onClick = onClick
    }
}

