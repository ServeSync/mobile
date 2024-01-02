//
//  EventVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit

class EventVC: BaseVC<EventVM> {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func initViews() {
        super.initViews()
        
        headerView.roundDifferentCorners(bottomLeft: 24, bottomRight: 24)
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        searchButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.pushVC(CalendarVC())
            })
            .disposed(by: bag)
    }
}
