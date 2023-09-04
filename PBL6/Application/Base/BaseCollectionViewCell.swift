//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupEventViews()
    }
    
    func setup() {}
    
    func setupEventViews() { }
}
