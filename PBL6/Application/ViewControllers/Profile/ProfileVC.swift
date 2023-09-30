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
    
    @IBOutlet weak var studentIDLabel: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }

}
