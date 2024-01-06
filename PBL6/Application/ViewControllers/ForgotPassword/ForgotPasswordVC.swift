//
//  ForgotPasswordVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit

class ForgotPasswordVC: BaseVC<ForgotPasswordVM> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailWarningLabel: UILabel!
    
    private var isValidateEmail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func initViews() {
        super.initViews()
        
        emailTextField.setLeftPaddingPoints(24)
        emailWarningLabel.isHidden = true
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        emailTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak emailTextField] in
                guard let emailTextField = emailTextField else { return }
                emailTextField.rx.text
                    .subscribe(onNext: { [weak self] text in
                        guard let self = self else { return }
                        if text!.isNotEmpty && self.isValidEmailOrStudentIDDigits(text!) {
                            emailTextField.borderColor = UIColor(named: "Primary")
                            emailWarningLabel.isHidden = true
                            viewModel.email = text!
                            isValidateEmail = true
                        } else {
                            emailTextField.borderColor = .red
                            emailWarningLabel.isHidden = false
                            isValidateEmail = false
                        }
                    })
                    .disposed(by: self.bag)
            })
            .disposed(by: bag)
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
        
        sendButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                if isValidateEmail {
                    viewModel.handleForgetPassword()
                        .subscribe(onNext: {[weak self] status in
                            guard let self = self else { return }
                            switch status {
                            case .Success:
                                self.showToast(message: "check_email".localized, state: .success)
                            case .Error(let error):
                                AlertVC.showMessage(self,
                                                    message: AlertMessage(type: .error,
                                                                          description: getErrorDescription(forErrorCode: error!.code))) {}
                            }
                        })
                        .disposed(by: bag)
                } else {
                    AlertVC.showMessage(self, message: AlertMessage(type: .error,
                                                                    description: "email_or_username_alert".localized)) {}
                }
                
            })
            .disposed(by: bag)
    }
}

extension ForgotPasswordVC {
    func isValidEmailOrStudentIDDigits(_ input: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let isEmail = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: input)
        
        let isNineDigits = input.range(of: #"^\d{9}$"#, options: .regularExpression) != nil
        
        return isEmail || isNineDigits
    }
}
