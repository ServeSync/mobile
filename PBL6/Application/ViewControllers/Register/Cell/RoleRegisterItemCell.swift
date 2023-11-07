//
//  RoleRegisterItemCell.swift
//  PBL6
//
//  Created by KietKoy on 02/11/2023.
//

import UIKit

class RoleRegisterItemCell: BaseCollectionViewCell {

    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ item: EventRoleDto) {
        nameLabel.text = item.name
        radioImage.isHighlighted = item.isSelected
    }
}
