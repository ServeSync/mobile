//
//  UIImageView.swift
//  PBL6
//
//  Created by KietKoy on 01/11/2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with resource: Resource?,
                  placeholder: Placeholder? = #imageLiteral(resourceName: "ic_mod_temp"),
                  onSuccess: (() -> Void)? = nil,
                  onError: (() -> Void)? = nil) {

        kf.indicatorType = .activity
        kf.indicator?.view.borderColor = Theme.Colors.primary
        
        kf.setImage(with: resource,
                    placeholder: placeholder,
                    options: [.transition(.fade(1)),
                              .cacheOriginalImage],
                    completionHandler: { result in
                        switch result {
                        case .success:
                            onSuccess?()
                        case .failure:
                            onError?()
                        }
                    })
    }
}
