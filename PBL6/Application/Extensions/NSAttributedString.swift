//
//  NSAttributedString.swift
//  PBL6
//
//  Created by KietKoy on 13/11/2023.
//

import Foundation
import UIKit

extension NSAttributedString {
    convenience init?(html: String) {
        
        let modifiedHTML = html.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let data = html.data(using: .utf8) else { return nil }

        try? self.init(data: data, options: options, documentAttributes: nil)
    }
}
