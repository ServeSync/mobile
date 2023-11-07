//
//  AccountVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit

class AccountVC: BaseVC<AccountVM> {
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var personInfoButton: UIButton!
    @IBOutlet weak var regulationsButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var avtImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func initViews() {
        super.initViews()
        
        headerView.roundDifferentCorners(bottomLeft: 24, bottomRight: 24)
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        personInfoButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                let vc = ProfileVC()
                vc.delegate = self
                self.pushVC(vc)
            })
            .disposed(by: bag)
        
        signOutButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                AppDelegate.shared().windowMainConfig(vc: LoginVC())
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
                nameLabel.text = data.fullName
                loadImageFromURL(from: data.imageUrl, into: avtImageView)
            })
            .disposed(by: bag)
    }
}

extension AccountVC: EditProfileDelegate {
    func updateView(studentEditProfileDto: StudentEditProfileDto) {
        loadImageFromURL(from: studentEditProfileDto.imageUrl, into: avtImageView)
    }
}
