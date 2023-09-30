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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
                self.pushVC(ProfileVC())
            })
            .disposed(by: bag)
    }

}
