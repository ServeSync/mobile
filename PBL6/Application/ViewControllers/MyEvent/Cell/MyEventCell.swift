//
//  MyEventCell.swift
//  PBL6
//
//  Created by KietKoy on 13/10/2023.
//

import UIKit

class MyEventCell: BaseCollectionViewCell {
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var nameEventLabel: UILabel!
    @IBOutlet weak var timeStartLabel: UILabel!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var timeEndLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(_ item: FlatEventDto) {
        eventImage.setImage(with: URL(string: item.imageUrl), placeholder: "img_event_thumb_default".toUIImage())
        nameEventLabel.text = item.name
        dateStartLabel.text = convertDateFormat(item.startAt, dateNeedFormat: "dd/MM/yyyy")
        timeStartLabel.text = convertDateFormat(item.startAt, dateNeedFormat: "HH:mm")
        
        dateEndLabel.text = convertDateFormat(item.endAt, dateNeedFormat: "dd/MM/yyyy")
        timeEndLabel.text = convertDateFormat(item.endAt, dateNeedFormat: "HH:mm")
        placeLabel.text = item.address.fullAddress
    }

}
