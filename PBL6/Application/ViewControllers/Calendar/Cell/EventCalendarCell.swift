//
//  EventCalendarCell.swift
//  PBL6
//
//  Created by KietKoy on 29/12/2023.
//

import UIKit

class EventCalendarCell: BaseCollectionViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var startAtLabel: UILabel!
    @IBOutlet weak var endAtLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ item: FlatEventDto) {
        eventNameLabel.text = item.name
        var date = convertStringToDate(item.startAt)
        date = date!.addingTimeInterval(7 * 60 * 60)
        startAtLabel.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm dd/MM/yyyy")
        date = convertStringToDate(item.endAt)
        date = date!.addingTimeInterval(7 * 60 * 60)
        endAtLabel.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm dd/MM/yyyy")
        loadImageFromURL(from: item.imageUrl, into: eventImage)
    }
}
