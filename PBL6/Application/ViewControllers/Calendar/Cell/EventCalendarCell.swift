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
        startAtLabel.text = convertDateFormat(item.startAt)
        endAtLabel.text = convertDateFormat(item.endAt)
        loadImageFromURL(from: item.imageUrl, into: eventImage)
    }
}
