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
    @IBOutlet weak var togglePasswordButton: UIButton!
    
    @IBOutlet weak var userNameWarningLabel: UILabel!
    @IBOutlet weak var passwordWarningLabel: UILabel!
    
    @IBOutlet weak var toggleIcon: UIImageView!
    
    private var isPasswordVisible = false
    private var isValidatePassword = false
    private var isValidateUserName = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func initViews() {
        super.initViews()
        
        emailTextField.setLeftIcon(UIImage(named: "ic_mail")!)
        emailTextField.placeholder = "email".localized
        emailTextField.setRightPaddingPoints(45)
        
        passwordTextField.setLeftIcon(UIImage(named: "ic_password")!)
        passwordTextField.placeholder = "password".localized
        passwordTextField.setRightPaddingPoints(45)
        passwordTextField.isSecureTextEntry = true
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        emailTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak emailTextField] in
                guard let emailTextField = emailTextField else { return }
                emailTextField.rx.text
                    .subscribe(onNext: { [weak self] text in
                        guard let self = self else { return }
                        if text!.isNotEmpty {
                            viewModel.userNameOrEmail = text!
                            
                            emailTextField.setLeftIcon(UIImage(named: "ic_mail")!)
                            emailTextField.borderColor = UIColor(named: "Primary")
                            self.userNameWarningLabel.isHidden = true
                            
                            isValidateUserName = true
                        } else {
                            emailTextField.setLeftIcon(UIImage(named: "ic_mail_err")!)
                            emailTextField.borderColor = .red
                            self.userNameWarningLabel.isHidden = false
                            
                            isValidateUserName = false
                        }
                    })
                    .disposed(by: self.bag)
            })
            .disposed(by: bag)
        
        passwordTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self, weak passwordTextField] in
                guard let self = self, let passwordTextField = passwordTextField else { return }
                passwordTextField.rx.text
                    .subscribe(onNext: { [weak self] text in
                        guard let self = self else { return }
                        if text!.isNotEmpty {
                            viewModel.password = text!
                            
                            passwordTextField.setLeftIcon(UIImage(named: "ic_password")!)
                            passwordTextField.borderColor = UIColor(named: "Primary")
                            self.passwordWarningLabel.isHidden = true
                            self.toggleIcon.image = self.isPasswordVisible ? "ic_show".toUIImage() : "ic_hide".toUIImage()
                            
                            isValidatePassword = true
                        } else {
                            passwordTextField.setLeftIcon(UIImage(named: "ic_password_err")!)
                            passwordTextField.borderColor = .red
                            self.passwordWarningLabel.isHidden = false
                            self.toggleIcon.image = self.isPasswordVisible ? "ic_show_err".toUIImage() : "ic_hide_err".toUIImage()
                            
                            isValidatePassword = false
                        }
                    })
                    .disposed(by: self.bag)
            })
            .disposed(by: bag)
        
        
        
        togglePasswordButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isPasswordVisible.toggle()
                self.toggleIcon.image = self.isPasswordVisible ? "ic_show".toUIImage() : "ic_hide".toUIImage()
                passwordTextField.isSecureTextEntry.toggle()
            })
            .disposed(by: bag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if !isValidatePassword || !isValidateUserName {
                    AlertVC.showMessage(self, message: AlertMessage(type: .error, 
                                                                    description: "username_or_password_validation_error".localized)) {}
                    return
                }
                
                viewModel.handleSignIn()
                    .subscribe(onNext: { [weak self] status in
                        guard let self = self else { return }
                        switch status {
                        case .Success:
                            AlertVC.showMessage(self, message: AlertMessage(type: .info, description: "login_successful".localized)) {
                                self.pushVC(MainVC())
                            }
                        case .Error(let message):
                            self.showError(message!)
                        }
                    })
                    .disposed(by: bag)
            })
            .disposed(by: bag)
        
        forgotPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.showWebviewVC(url: Configs.Server.forgotPasswordURL)
            })
            .disposed(by: bag)
    }
    
}
