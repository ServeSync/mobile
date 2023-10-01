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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        homeTownTextField.setLeftPaddingPoints(24)
        addressTextField.setLeftPaddingPoints(24)
        emailTextField.setLeftPaddingPoints(24)
        phoneNumberTextField.setLeftPaddingPoints(24)
        
        homeTownTextField.text = viewModel.profileDetail!.homeTown
        addressTextField.text = viewModel.profileDetail!.address
        emailTextField.text = viewModel.profileDetail!.email
        phoneNumberTextField.text = viewModel.profileDetail!.phone
        
        nameLabel.text = viewModel.profileDetail?.fullName
        
        loadImageFromURL(from: viewModel.profileDetail!.imageUrl, into: avtImageView)
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
    }
}
