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
        var date = convertStringToDate(item.startAt)
        date = date!.addingTimeInterval(7 * 60 * 60)
        dateStartLabel.text = FormatUtils.formatDateToString(date!, formatterString: "dd/MM/yyyy")
        timeStartLabel.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm")
        
        date = convertStringToDate(item.endAt)
        date = date!.addingTimeInterval(7 * 60 * 60)
        dateEndLabel.text = FormatUtils.formatDateToString(date!, formatterString: "dd/MM/yyyy")
        timeEndLabel.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm")
        placeLabel.text = item.address.fullAddress
    }

}
