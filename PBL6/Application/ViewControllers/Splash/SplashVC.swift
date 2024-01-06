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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.handleRedirect()
        })
    }
                                      
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func initViews() {
        indicatorView.startAnimating()
    }
    
    func handleRedirect() {
        let accessToken = UserDefaultHelper.shared.accessToken
        if UserDefaultHelper.shared.firstLaunchApp {
            AppDelegate.shared().windowMainConfig(vc: WelcomeVC())
        } else if accessToken!.isEmpty {
            AppDelegate.shared().windowMainConfig(vc: LoginVC())
        } else if let tokenInfo = JWTHelper.shared.decodeAndMap(jwtToken: accessToken!, to: TokenInfo.self), !JWTHelper.shared.isTokenExpired(expirationDate: Date(timeIntervalSince1970: TimeInterval(tokenInfo.exp))) {
            AppDelegate.shared().windowMainConfig(vc: MainVC())
        } else {
            viewModel.refreshToken()
                .subscribe(onNext: {[weak self] status in
                    guard let self = self else { return }
                    switch status {
                    case .Success:
                        AppDelegate.shared().windowMainConfig(vc: MainVC())
                    default:
                        AppDelegate.shared().windowMainConfig(vc: LoginVC())
                    }
                })
                .disposed(by: bag)
        }
    }
}
