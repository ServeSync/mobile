//
//  ProofItemCell.swift
//  PBL6
//
//  Created by KietKoy on 29/11/2023.
//

import UIKit

class ProofItemCell: BaseCollectionViewCell {
    
    @IBOutlet weak var proofNameLabel: UILabel!
    @IBOutlet weak var proofStateLabel: UILabel!
    
    @IBOutlet weak var proofStateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        proofStateView.roundDifferentCorners( topRight: 11, bottomRight: 11)
    }

    func configure(_ item: ProofItem) {
        proofNameLabel.text = item.name
        proofStateLabel.text = item.status
    }
}
