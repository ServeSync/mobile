//
//  WelcomeSlideCell.swift
//  PBL6
//
//  Created by KietKoy on 11/09/2023.
//

import UIKit

class WelcomeSlideCell: BaseCollectionViewCell {
    
    @IBOutlet weak var slideImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ item: SlideItem) {
        slideImage.image = item.img.toUIImage()
        titleLabel.text = item.title
    }
}
