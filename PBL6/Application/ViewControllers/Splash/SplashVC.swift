//
//  SplashVC.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import UIKit

class SplashVC: BaseVC<SplashVM> {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            AppDelegate.shared().windowMainConfig()
        })
    }
    
    override func initViews() {
        indicatorView.startAnimating()
    }
    
}
