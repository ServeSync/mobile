//
//  ExportStudentAttendanceEventsDto.swift
//  PBL6
//
//  Created by KietKoy on 24/11/2023.
//

import Foundation
import ObjectMapper

struct ExportStudentAttendanceEventsDto: Mappable {
    var fromDate: String = ""
    var toDate: String = ""
    
    init(fromDate: String, toDate: String) {
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        fromDate <- map["fromDate"]
        toDate <- map["toDate"]
    }
}
