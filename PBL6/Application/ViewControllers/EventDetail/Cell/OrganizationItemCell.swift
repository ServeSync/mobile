//
//  OrganizationItemCell.swift
//  PBL6
//
//  Created by KietKoy on 29/10/2023.
//

import UIKit

class OrganizationItemCell: BaseCollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ item: OrganizationInEventDto) {
        loadImageFromURL(from: item.imageUrl, into: imageView)
        nameLabel.text = item.name
        addressLabel.text = item.address
        emailLabel.text = item.email
        phoneLabel.text = item.phoneNumber
    }
}
