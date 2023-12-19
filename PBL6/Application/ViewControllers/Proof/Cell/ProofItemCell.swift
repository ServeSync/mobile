//
//  ProofItemCell.swift
//  PBL6
//
//  Created by KietKoy on 29/11/2023.
//

import UIKit
import SwipeCellKit

class ProofItemCell: SwipeCollectionViewCell {
    
    @IBOutlet weak var proofNameLabel: UILabel!
    @IBOutlet weak var proofStateLabel: UILabel!
    
    @IBOutlet weak var proofStateView: UIView!
    
    private var onDeleteButtonTouched: ((ProofDto) -> Void)? = nil
    private var item: ProofDto!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ item: ProofDto, onDeleteButtonTouched: ((ProofDto) -> Void)?) {
        self.item = item
        
        proofNameLabel.text = item.eventName
        proofStateLabel.text = "\(item.proofStatus.lowercased())_proof".localized
        
        self.onDeleteButtonTouched = onDeleteButtonTouched
        switch item.proofStatus {
        case ProofStatus.Pending.rawValue:
            proofStateView.backgroundColor = "#F3DA65".toUIColor()
        case ProofStatus.Rejected.rawValue:
            proofStateView.backgroundColor = "#F07C6A".toUIColor()
        default:
            proofStateView.backgroundColor = "#67DA64".toUIColor()
        }
        self.delegate = self
    }
}

extension ProofItemCell: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Xoá") { [weak self] action, indexPath in
            guard let self = self else { return }
            self.onDeleteButtonTouched?(item)
        }
        deleteAction.image = UIImage(named: "delete")
        
        let editAction = SwipeAction(style: .destructive, title: "Chỉnh sửa") { [weak self] action, indexPath in
            guard let self = self else { return }
        }
        editAction.backgroundColor = "26C6DA".toUIColor()
        
        return [deleteAction, editAction]
    }
}
