//
//  DateFormatHelper.swift
//  PBL6
//
//  Created by KietKoy on 12/11/2023.
//

import Foundation

func convertDateFormat(_ dateString: String, dateNeedFormat: String = "HH:mm dd/MM/yyyy") -> String? {
    let dateFormats = [
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
        "yyyy-MM-dd'T'HH:mm:ss.SSZ",
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    ]
    
    for dateFormat in dateFormats {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = dateFormat
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = dateNeedFormat
            return outputFormatter.string(from: date)
        }
    }
    return nil
}
