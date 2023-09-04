//
//  AppDelegate.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        windowMainConfig()
        
        return true
    }

}

extension AppDelegate {
    
    private func windowSplashConfig() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = SplashVC()
        window?.makeKeyAndVisible()
    }
    
    func windowMainConfig() {
        windowSplashConfig()
        
        guard let window = window else { return }
        let vc = HomeVC()
        let nvc = BaseNVC(rootViewController: vc)
        
        window.rootViewController = nvc
    }
}

