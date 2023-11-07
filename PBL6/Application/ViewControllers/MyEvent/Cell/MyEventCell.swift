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
        var date = FormatUtils.formatStringToDate(item.startAt, formatterString: "yyyy-MM-dd'T'HH:mm:ss")
        var dateString = FormatUtils.formatDateToString(date, formatterString: "dd/MM/yyyy")
        var timeString = FormatUtils.formatDateToString(date, formatterString: "HH:mm")
        dateStartLabel.text = dateString
        timeStartLabel.text = timeString
        
        date = FormatUtils.formatStringToDate(item.endAt, formatterString: "yyyy-MM-dd'T'HH:mm:ss")
        dateString = FormatUtils.formatDateToString(date, formatterString: "dd/MM/yyyy")
        timeString = FormatUtils.formatDateToString(date, formatterString: "HH:mm")
        dateEndLabel.text = dateString
        timeEndLabel.text = timeString
        placeLabel.text = item.address.fullAddress
    }

}
