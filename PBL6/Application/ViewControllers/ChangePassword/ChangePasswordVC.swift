//
//  ChangePasswordVC.swift
//  PBL6
//
//  Created by KietKoy on 20/11/2023.
//

import UIKit

class ChangePasswordVC: BaseVC<ChangePasswordVM> {
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var isValidNewPassword = false
    private var isValidOldPassword = false
    private var isValidConfirmPassword = false
    
    private var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        activeTextField?.resignFirstResponder()
    }
    
    override func initViews() {
        super.initViews()
        
        oldPasswordTextField.setLeftPaddingPoints(16)
        oldPasswordTextField.setRightPaddingPoints(16)
        oldPasswordTextField.isSecureTextEntry = true
        oldPasswordTextField.delegate = self
        
        newPasswordTextField.setLeftPaddingPoints(16)
        newPasswordTextField.setRightPaddingPoints(16)
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.delegate = self
        
        confirmPasswordTextField.setLeftPaddingPoints(16)
        confirmPasswordTextField.setRightPaddingPoints(16)
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.delegate = self
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                if !isValidOldPassword || !isValidOldPassword || !isValidConfirmPassword{
                    AlertVC.showMessage(self,
                                        message: AlertMessage(type: .error,
                                                                    description: "alert_message_invalid_change_password".localized)) {}
                } else if viewModel.newPassword != viewModel.confirmPassword {
                    AlertVC.showMessage(self,
                                        message: AlertMessage(type: .error,
                                                                    description: "new_password_not_match_confirm_password_alert_message".localized)) {}
                    
                }
            })
            .disposed(by: bag)
        
        oldPasswordTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self, weak oldPasswordTextField] in
                guard let self = self, let oldPasswordTextField = oldPasswordTextField else { return }
                oldPasswordTextField.rx.text
                    .subscribe(onNext: { [weak self] text in
                        guard let self = self else { return }
                        if text!.isNotEmpty {
                            oldPasswordTextField.borderColor = UIColor(named: "Primary")
                            isValidOldPassword = true
                            viewModel.oldPassword = text!
                        } else {
                            oldPasswordTextField.borderColor = .red
                            isValidOldPassword = false
                        }
                    })
                    .disposed(by: self.bag)
            })
            .disposed(by: bag)
        
        newPasswordTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self, weak newPasswordTextField] in
                guard let self = self, let newPasswordTextField = newPasswordTextField else { return }
                newPasswordTextField.rx.text
                    .subscribe(onNext: { [weak self] text in
                        guard let self = self else { return }
                        if text!.isNotEmpty {
                            newPasswordTextField.borderColor = UIColor(named: "Primary")
                            isValidNewPassword = true
                            viewModel.newPassword = text!
                        } else {
                            newPasswordTextField.borderColor = .red
                            isValidNewPassword = false
                        }
                    })
                    .disposed(by: self.bag)
            })
            .disposed(by: bag)
        
        confirmPasswordTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self, weak confirmPasswordTextField] in
                guard let self = self, let confirmPasswordTextField = confirmPasswordTextField else { return }
                confirmPasswordTextField.rx.text
                    .subscribe(onNext: { [weak self] text in
                        guard let self = self else { return }
                        if text!.isNotEmpty {
                            confirmPasswordTextField.borderColor = UIColor(named: "Primary")
                            isValidConfirmPassword = true
                            viewModel.confirmPassword = text!
                        } else {
                            confirmPasswordTextField.borderColor = .red
                            isValidConfirmPassword = false
                        }
                    })
                    .disposed(by: self.bag)
            })
            .disposed(by: bag)
    }
    
    @objc override func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc override func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension ChangePasswordVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 255
        
        if let text = textField.text {
            let newLength = text.count + string.count - range.length
            
            if newLength > maxLength {
                return false
            }
        }
        return true
    }
    
}
