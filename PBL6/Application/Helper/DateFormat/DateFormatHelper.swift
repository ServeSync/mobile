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

func convertStringToDate(_ dateString: String) -> Date? {
    let dateFormats = [
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
        "yyyy-MM-dd'T'HH:mm:ss.SSZ",
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    ]

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    for format in dateFormats {
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
    }

    return nil
}

func compareDatesIgnoringTime(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current
    let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
    let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

    return components1 == components2
}
