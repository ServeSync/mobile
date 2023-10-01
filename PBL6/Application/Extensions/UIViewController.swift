//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import Foundation
import UIKit
import MKProgress
import Loaf
import AVFoundation
import Photos

extension UIViewController {
    func showLoading() {
        MKProgress.show()
    }
    
    func hideLoading() {
        MKProgress.hide()
    }
    
    func showToast(
        message: String,
        state: Loaf.State = .error
    ) {
        Loaf(message, state: state, location: .top, sender: self).show()
    }
    
    func showGeneralError(onClick: (() -> Void)? = nil) {
        AlertVC.showMessage(self, style: .error, message: "general_error_message".localized, onClick: onClick)
    }
    
    func showError(_ message: String, onClick: (() -> Void)? = nil) {
        AlertVC.showMessage(self, style: .error, message: message, onClick: onClick)
    }
    
    func addChildToView(_ child: UIViewController, toView view: UIView) {
        addChild(child)
        child.view.frame = view.bounds
        view.addSubview(child.view)
        
        child.didMove(toParent: self)
    }
    
    func removeOutParent() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else {
            return self
        }
    }
    
    var previousViewController:UIViewController?{
        if let controllersOnNavStack = self.navigationController?.viewControllers, controllersOnNavStack.count >= 2 {
            let n = controllersOnNavStack.count
            return controllersOnNavStack[n - 2]
        }
        return nil
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentVC(_ vc: UIViewController, completion: (() -> Void)? = nil) {
        present(vc, animated: true, completion: completion)
    }
    
    func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismissVC() {
        dismiss(animated: true)
    }
    
    func showWebviewVC(url: String) {
        let webviewVC = WebviewVC()
        webviewVC.urlString = url
        webviewVC.modalPresentationStyle = .fullScreen
        presentVC(webviewVC)
    }
}

extension UIViewController {
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

