//
//  DateFormatHelper.swift
//  PBL6
//
//  Created by KietKoy on 12/11/2023.
//

import Foundation

func convertDateFormat(_ dateString: String, dateNeedFormat: String = "HH:mm dd/MM/yyyy", dateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = dateFormat
    
    if let date = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = dateNeedFormat
        return outputFormatter.string(from: date)
    } else {
        return nil
    }
}
