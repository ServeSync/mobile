//
//  EventItemCell.swift
//  PBL6
//
//  Created by KietKoy on 10/10/2023.
//

import UIKit

class EventItemCell: BaseCollectionViewCell {
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameEventLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: FlatEventDto) {
        loadImageFromURL(from: item.imageUrl, into: thumbImage)
        nameEventLabel.text = item.name
        
        timeLabel.text = item.startAt
        placeLabel.text = item.address.fullAddress
    }
}
