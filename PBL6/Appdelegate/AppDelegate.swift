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
    
//    func windowMainConfig() {
//        var vc: UIViewController?
//        if UserDefaultHelper.shared.firstLaunchApp {
//            vc = WelcomeVC()
//        } else {
//            vc = LoginVC()
//        }
//        let nvc = BaseNVC(rootViewController: vc!)
//        
//        window?.rootViewController = nvc
//        window?.makeKeyAndVisible()
//    }
    
//    func windowMainConfig() {
//        var rootViewController: UIViewController?
//        
//        if UserDefaultHelper.shared.firstLaunchApp {
//            rootViewController = WelcomeVC()
//        } else if let accessToken = UserDefaultHelper.shared.accessToken,
//                  !accessToken.isEmpty,
//                  let tokenInfo = JWTHelper.shared.decodeAndMap(jwtToken: accessToken, to: TokenInfo.self),
//                  !JWTHelper.shared.isTokenExpired(expirationDate: Date(timeIntervalSince1970: TimeInterval(tokenInfo.exp))) {
//            rootViewController = HomeVC()
//        } else {
//            remoteRepository.refreshTokenIfNeed()
//                .asObservable()
//                .subscribe(onNext: { [weak self] in
//                    guard let self = self else { return }
//                    if let accessToken = UserDefaultHelper.shared.accessToken,
//                       !accessToken.isEmpty,
//                       let tokenInfo = JWTHelper.shared.decodeAndMap(jwtToken: accessToken, to: TokenInfo.self),
//                       !JWTHelper.shared.isTokenExpired(expirationDate: Date(timeIntervalSince1970: TimeInterval(tokenInfo.exp))) {
//                        rootViewController = HomeVC()
//                    } else {
//                        rootViewController = LoginVC()
//                    }
//                    setRootViewController(rootViewController!)
//                })
//                .disposed(by: DisposeBag())
//            return 
//        }
//
//        setRootViewController(rootViewController!)
//    }
    
    func windowMainConfig() {
        var rootViewController: UIViewController
        
        if UserDefaultHelper.shared.firstLaunchApp {
            rootViewController = WelcomeVC()
        } else if let accessToken = UserDefaultHelper.shared.accessToken,
                   !accessToken.isEmpty,
                   let tokenInfo = JWTHelper.shared.decodeAndMap(jwtToken: accessToken, to: TokenInfo.self) {
            if !JWTHelper.shared.isTokenExpired(expirationDate: Date(timeIntervalSince1970: TimeInterval(tokenInfo.exp))) {
                rootViewController = HomeVC()
            } else {
                refreshAndSetRootViewController { [weak self] viewController in
                    guard let self = self else { return }
                    setRootViewController(viewController)
                }
                return
            }
        } else {
            rootViewController = LoginVC()
        }

        setRootViewController(rootViewController)
    }

    func refreshAndSetRootViewController(completion: @escaping (UIViewController) -> Void) {
        remoteRepository.refreshTokenIfNeed()
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                var rootViewController: UIViewController
                if let accessToken = UserDefaultHelper.shared.accessToken,
                   !accessToken.isEmpty,
                   let tokenInfo = JWTHelper.shared.decodeAndMap(jwtToken: accessToken, to: TokenInfo.self),
                   !JWTHelper.shared.isTokenExpired(expirationDate: Date(timeIntervalSince1970: TimeInterval(tokenInfo.exp))) {
                    rootViewController = HomeVC()
                } else {
                    rootViewController = LoginVC()
                }
                completion(rootViewController)
            })
            .disposed(by: DisposeBag())
    }

    func setRootViewController(_ viewController: UIViewController) {
        let navigationController = BaseNVC(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

