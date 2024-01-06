//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 04/10/2023.
//

import Foundation

class FormatUtils {
    
    static func formatDateToString(_ date: Date, formatterString: String = "dd MMM yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        return formatter.string(from: date)
    }
    
    static func formatStringToDate(_ text: String, formatterString: String = "dd MMM yyyy HH:mm") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        return formatter.date(from: text) ?? Date()
    }
}
