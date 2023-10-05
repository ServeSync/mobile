//
//  ProfileVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit

class ProfileVC: BaseVC<ProfileVM> {
    @IBOutlet weak var parentTopview: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var parentMiddleView: UIView!
    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var studentIDLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var citizenIDLabel: UILabel!
    @IBOutlet weak var educationalSystemLabel: UILabel!
    @IBOutlet weak var facultyLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var homeTownLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var avtImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchData()
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    return
                case .Error(let error):
                    if error?.code == Configs.Server.errorCodeRequiresLogin {
                        AppDelegate.shared().windowMainConfig(vc: LoginVC())
                    } else {
                        viewModel.messageData.accept(AlertMessage(type: .error,
                                                                  description: getErrorDescription(forErrorCode: error!.code)))
                    }
                }
            })
            .disposed(by: bag)
    }
    
    override func initViews() {
        super.initViews()
        
        parentTopview.roundDifferentCorners(bottomLeft: 24, bottomRight: 24)
        topView.addDropShadow(shadowRadius: 4, offset: CGSize(width: 0, height: 4), color: UIColor(hex: 0x000000, alpha: 0.25))
        
        parentMiddleView.roundDifferentCorners(bottomLeft: 24, bottomRight: 24)
        middleView.addDropShadow(shadowRadius: 4, offset: CGSize(width: 0, height: 4), color: UIColor(hex: 0x000000, alpha: 0.25))
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        backButton.rx.tap
            .subscribe(onNext: { [ weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
        
        editButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = EditProfileVC(profileDetail: viewModel.profileDetail!)
                vc.modalPresentationStyle = .fullScreen
                self.presentVC(vc)
            })
            .disposed(by: bag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.messageData.asObservable()
            .subscribe(onNext: { [weak self] alert in
                guard let self = self else { return }
                AlertVC.showMessage(self, message: AlertMessage(type: alert.type,
                                                                description: alert.description)) {}
            })
            .disposed(by: bag)
        
        viewModel.loadingData.asObservable()
            .subscribe(onNext: {[weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.showLoading() : self.hideLoading()
            })
            .disposed(by: bag)
        
        viewModel.profileDetailData.asObservable()
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                configUI(data)
            })
            .disposed(by: bag)
    }

}

private extension ProfileVC {
    private func configUI(_ data: StudentDetailDto) {
        loadImageFromURL(from: data.imageUrl, into: avtImageView)
        nameLabel.text = data.fullName
        studentIDLabel.text = data.code
        genderLabel.text = data.gender ? "female".localized : "male".localized
        let date = FormatUtils.formatStringToDate(data.dateOfBirth, formatterString: "yyyy-MM-dd'T'HH:mm:ss")
        let dateString = FormatUtils.formatDateToString(date, formatterString: "dd/MM/yyyy")
        dateOfBirthLabel.text = dateString
        citizenIDLabel.text = data.citizenId
        educationalSystemLabel.text = data.educationProgram.name
        facultyLabel.text = data.faculty.name
        classLabel.text = data.homeRoom.name
        homeTownLabel.text = data.homeTown
        addressLabel.text = data.address
        emailLabel.text = data.email
        phoneNumberLabel.text = data.phone
    }
}
