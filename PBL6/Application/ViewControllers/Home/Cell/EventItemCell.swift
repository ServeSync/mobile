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
        thumbImage.setImage(with: URL(string: item.imageUrl), placeholder: "img_event_thumb_default".toUIImage())
        nameEventLabel.text = item.name
        
        var date = FormatUtils.formatStringToDate(item.startAt, formatterString: "yyyy-MM-dd'T'HH:mm:ss")
        date = date.addingTimeInterval(7 * 60 * 60)
        let dateString = FormatUtils.formatDateToString(date, formatterString: "dd/MM/yyyy")
        timeLabel.text = dateString
        
        placeLabel.text = item.address.fullAddress
    }
    
    func configureFavoriteItem(item: EventDetailDto) {
        thumbImage.setImage(with: URL(string: item.imageUrl), placeholder: "img_event_thumb_default".toUIImage())
        nameEventLabel.text = item.name
        
        var date = FormatUtils.formatStringToDate(item.startAt, formatterString: "yyyy-MM-dd'T'HH:mm:ss")
        date = date.addingTimeInterval(7 * 60 * 60)
        let dateString = FormatUtils.formatDateToString(date, formatterString: "dd/MM/yyyy")
        timeLabel.text = dateString
        
        placeLabel.text = item.address.fullAddress
    }
}
