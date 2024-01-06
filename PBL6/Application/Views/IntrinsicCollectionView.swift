//
//  IntrinsicCollectionView.swift
//  BaseProject
//
//  Created by KietKoy on 26/10/2023.
//

import UIKit

final class IntrinsicCollectionView: UICollectionView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
}
