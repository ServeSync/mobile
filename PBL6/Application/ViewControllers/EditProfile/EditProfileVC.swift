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
    
    var activeTextField : UITextField? = nil
    
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
        setupTextField()
        
        loadImageFromURL(from: viewModel.profileDetail!.imageUrl, into: avtImageView)
        
        homeTownTextField.delegate = self
        addressTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        
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
                
            })
            .disposed(by: bag)
        
        pickImageButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
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
        view.endEditing(true)
    }
}

extension EditProfileVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}

private extension EditProfileVC {
    private func setupTextField() {
        homeTownTextField.setLeftPaddingPoints(24)
        addressTextField.setLeftPaddingPoints(24)
        emailTextField.setLeftPaddingPoints(24)
        phoneNumberTextField.setLeftPaddingPoints(24)
        
        homeTownTextField.text = viewModel.profileDetail!.homeTown
        addressTextField.text = viewModel.profileDetail!.address
        emailTextField.text = viewModel.profileDetail!.email
        phoneNumberTextField.text = viewModel.profileDetail!.phone
    }
}
