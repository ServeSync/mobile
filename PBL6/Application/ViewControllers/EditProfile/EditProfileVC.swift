//
//  EditProfileVC.swift
//  PBL6
//
//  Created by KietKoy on 01/10/2023.
//

import UIKit

class EditProfileVC: BaseVC<EditProfileVM> {
    
    @IBOutlet weak var parentTopview: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var pickImageButton: UIButton!
    
    @IBOutlet weak var avtImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var homeTownTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var homeTownWarningLabel: UILabel!
    @IBOutlet weak var addressWarningLabel: UILabel!
    @IBOutlet weak var emailWarningLabel: UILabel!
    @IBOutlet weak var phoneWarningLabel: UILabel!
    
    private var isValidHomeTown = true
    private var isValidAddress = true
    private var isValidEmail = true
    private var isValidPhone = true
    
    private var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        activeTextField?.resignFirstResponder()
    }
    
    init(profileDetail: StudentDetailDto) {
        super.init()
        
        viewModel.profileDetail = profileDetail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        super.initViews()
        
        parentTopview.roundDifferentCorners(bottomLeft: 24, bottomRight: 24)
        topView.addDropShadow(shadowRadius: 4, offset: CGSize(width: 0, height: 4), color: UIColor(hex: 0x000000, alpha: 0.25))
        
        nameLabel.text = viewModel.profileDetail?.fullName
        loadImageFromURL(from: viewModel.profileDetail!.imageUrl, into: avtImageView)
        setupTextField()
        
        emailTextField.keyboardType = .emailAddress
        phoneNumberTextField.keyboardType = .phonePad
        
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismissVC()
            })
            .disposed(by: bag)
        
        saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if isValidEmail && isValidPhone && isValidHomeTown && isValidAddress {
                    viewModel.handleUpdateProfile()
                        .subscribe(onNext: {[weak self] status in
                            guard let self = self else { return }
                            switch status {
                            case .Success:
                                self.showToast(message: "edit_success".localized, state: .success)
                                self.updateView(studentEditProfileDto: self.viewModel.studentEditProfileDto!)
                            case .Error(let error):
                                if error?.code == Configs.Server.errorCodeRequiresLogin {
                                    AppDelegate.shared().windowMainConfig(vc: LoginVC())
                                } else {
                                    AlertVC.showMessage(self,
                                                        message: AlertMessage(type: .error,
                                                                              description: getErrorDescription(forErrorCode: error!.code))) {}
                                }
                            }
                        })
                        .disposed(by: bag)
                } else {
                    AlertVC.showMessage(self,
                                        message: AlertMessage(type: .error,
                                                              description: "data_alert_warning".localized)) {}
                }
            })
            .disposed(by: bag)
        
        pickImageButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                showImagePicker()
            })
            .disposed(by: bag)
        
        homeTownTextField.rx.text
            .subscribe(onNext: {[weak self] text in
                guard let self = self else { return }
                if text!.isNotEmpty {
                    self.homeTownWarningLabel.isHidden = true
                    isValidHomeTown = true
                    viewModel.homeTown = text!
                    homeTownTextField.borderColor = UIColor(hex: 0xA0A2A4)
                } else {
                    self.homeTownWarningLabel.isHidden = false
                    isValidHomeTown = false
                    homeTownTextField.borderColor = .red
                }
            })
            .disposed(by: bag)
        
        addressTextField.rx.text
            .subscribe(onNext: {[weak self] text in
                guard let self = self else { return }
                if text!.isNotEmpty {
                    self.addressWarningLabel.isHidden = true
                    isValidAddress = true
                    viewModel.address = text!
                    addressTextField.borderColor = UIColor(hex: 0xA0A2A4)
                } else {
                    self.addressWarningLabel.isHidden = false
                    isValidAddress = false
                    addressTextField.borderColor = .red
                }
            })
            .disposed(by: bag)
        
        emailTextField.rx.text
            .subscribe(onNext: {[weak self] text in
                guard let self = self else { return }
                if text!.isNotEmpty && isValidEmail(email: text!) {
                    self.emailWarningLabel.isHidden = true
                    isValidEmail = true
                    viewModel.email = text!
                    emailTextField.borderColor = UIColor(hex: 0xA0A2A4)
                } else {
                    self.emailWarningLabel.isHidden = false
                    isValidEmail = false
                    emailTextField.borderColor = .red
                }
            })
            .disposed(by: bag)
        
        phoneNumberTextField.rx.text
            .subscribe(onNext: {[weak self] text in
                guard let self = self else { return }
                if text!.isNotEmpty && isValidPhoneNumber(text!) {
                    self.phoneWarningLabel.isHidden = true
                    isValidPhone = true
                    viewModel.phone = text!
                    phoneNumberTextField.borderColor = UIColor(hex: 0xA0A2A4)
                } else {
                    self.phoneWarningLabel.isHidden = false
                    isValidPhone = false
                    phoneNumberTextField.borderColor = .red
                }
            })
            .disposed(by: bag)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var shouldMoveViewUp = false
        
        if let activeTextField = activeTextField {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        
        self.view.frame.origin.y = 0
        //        view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate

extension EditProfileVC: UITextFieldDelegate {
    
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

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            avtImageView.image = selectedImage
            viewModel.avtImage = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - Setup View
private extension EditProfileVC {
    private func setupTextField() {
        homeTownTextField.setLeftPaddingPoints(24)
        addressTextField.setLeftPaddingPoints(24)
        emailTextField.setLeftPaddingPoints(24)
        phoneNumberTextField.setLeftPaddingPoints(24)
        
        homeTownTextField.setRightPaddingPoints(24)
        addressTextField.setRightPaddingPoints(24)
        emailTextField.setRightPaddingPoints(24)
        phoneNumberTextField.setRightPaddingPoints(24)
        
        homeTownTextField.delegate = self
        addressTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        homeTownTextField.text = viewModel.profileDetail!.homeTown
        addressTextField.text = viewModel.profileDetail!.address
        emailTextField.text = viewModel.profileDetail!.email
        phoneNumberTextField.text = viewModel.profileDetail!.phone
        
        viewModel.homeTown = viewModel.profileDetail!.homeTown
        viewModel.address = viewModel.profileDetail!.address
        viewModel.email = viewModel.profileDetail!.email
        viewModel.phone = viewModel.profileDetail!.phone
    }
    
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func updateView(studentEditProfileDto: StudentEditProfileDto) {
        homeTownTextField.text = studentEditProfileDto.homeTown
        addressTextField.text = studentEditProfileDto.address
        emailTextField.text = studentEditProfileDto.email
        phoneNumberTextField.text = studentEditProfileDto.phone
        
        loadImageFromURL(from: studentEditProfileDto.imageUrl, into: avtImageView)
    }
}

extension EditProfileVC {
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ text: String) -> Bool {
        let phoneNumberRegex = #"^\d{10}$"#
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return predicate.evaluate(with: text)
    }
}
