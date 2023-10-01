//
//  KingFisher.swift
//  PBL6
//
//  Created by KietKoy on 01/10/2023.
//

import UIKit
import Kingfisher

func loadImageFromURL(from imagePath: String, into imageView: UIImageView) {
    imageView.kf.setImage(with: URL(string: imagePath), placeholder: "img_avt_default".toUIImage())
}
