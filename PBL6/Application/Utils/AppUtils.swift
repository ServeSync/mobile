//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import Foundation
import UIKit
import StoreKit
import AppTrackingTransparency
import AdSupport

class AppUtils {
    
    static func goToAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func openURL(_ parentVC: UIViewController, url: URL, onCompleted: (() -> Void)? = nil) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func requestIDFA(_ onCompleted: (() -> Void)? = nil) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .denied:
                    print("Tracking denied")
                case .notDetermined:
                    print("Tracking notDetermined")
                case .restricted:
                    print("Tracking restricted")
                case .authorized:
                    print("Tracking authorized")
                @unknown default:
                    break
                }
                onCompleted?()
            })
        } else {
            onCompleted?()
        }
    }
}

extension AppUtils {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        AppDelegate.shared().orientationLock = orientation
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}

