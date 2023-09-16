//
//  LoginVC.swift
//  PBL6
//
//  Created by KietKoy on 15/09/2023.
//

import UIKit

class LoginVC: BaseVC<LoginVM> {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func initViews() {
        super.initViews()
        
        emailTextField.setLeftIcon(UIImage(named: "ic_mail")!)
        emailTextField.placeholder = "email".localized
        
        passwordTextField.setLeftIcon(UIImage(named: "ic_password")!)
        passwordTextField.setRightIcon(UIImage(named: "ic_hide")!)
        passwordTextField.placeholder = "password".localized
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
            })
            .disposed(by: bag)
        
        forgotPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
            })
            .disposed(by: bag)
    }

}
