//
//  AnalysisVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit

class AnalysisVC: BaseVC<AnalysisVM> {
    
    @IBOutlet weak var charts: CircleCharts!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.charts.circleBorderColor = UIColor(hex: 0x26C6DA, alpha: 0.5)
        self.charts.circleFilledColor = UIColor(hex: 0x26C6DA, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.charts.percentage = 0.9
        self.charts.progressAnimation(duration: 1.5)
    }
    
}
