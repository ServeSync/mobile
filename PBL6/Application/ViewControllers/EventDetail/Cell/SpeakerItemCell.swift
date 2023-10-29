//
//  SpeakerItemCell.swift
//  PBL6
//
//  Created by KietKoy on 28/10/2023.
//

import UIKit

class SpeakerItemCell: BaseCollectionViewCell {
    
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ item: BasicRepresentativeInEventDto) {
        loadImageFromURL(from: item.imageUrl, into: speakerImage)
        nameLabel.text = item.name
        positionLabel.text = item.position
    }
}
