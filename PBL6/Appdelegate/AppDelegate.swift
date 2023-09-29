//
//  AppDelegate.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import UIKit
import RxSwift
import RxCocoa

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    
    @Inject
    var remoteRepository: RemoteRepository
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        windowSplashConfig()
        
        return true
    }

}

extension AppDelegate {
    
    private func windowSplashConfig() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = SplashVC()
        window?.makeKeyAndVisible()
    }
    
    func windowMainConfig(vc: UIViewController) {
        let navigationController = BaseNVC(rootViewController: vc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

