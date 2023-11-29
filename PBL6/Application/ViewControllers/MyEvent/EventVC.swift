//
//  EventVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit

class EventVC: BaseVC<EventVM> {

    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func initViews() {
        super.initViews()
        
        headerView.roundDifferentCorners(bottomLeft: 24, bottomRight: 24)
    }
}
