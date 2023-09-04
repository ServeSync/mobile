//
//  BaseNVC.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import UIKit

class BaseNVC: UINavigationController {
    
    var isLightForegroundStatusBar = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightForegroundStatusBar ? .lightContent : .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
