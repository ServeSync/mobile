//
//  DetailItemCell.swift
//  PBL6
//
//  Created by KietKoy on 13/10/2023.
//

import UIKit

class DetailItemCell: BaseCollectionViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ item: StudentAttendanceEventDto) {
        eventNameLabel.text = item.name
        scoreLabel.text = "\(item.score)"
    }
}
