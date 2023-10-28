//
//  RoleItemCell.swift
//  PBL6
//
//  Created by KietKoy on 25/10/2023.
//

import UIKit

class RoleItemCell: BaseCollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ item: EventRoleDto) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        quantityLabel.text = "\(item.quantity)"
        scoreLabel.text = "\(item.score)"
    }
}
