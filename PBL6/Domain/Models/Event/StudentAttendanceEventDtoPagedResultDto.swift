//
//  StudentAttendanceEventDtoPagedResultDto.swift
//  PBL6
//
//  Created by KietKoy on 12/11/2023.
//

import Foundation
import ObjectMapper

struct StudentAttendanceEventDtoPagedResultDto: Mappable {
    var total: Int = 0
    var totalPages: Int = 0
    var data: [StudentAttendanceEventDto] = []
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        total <- map["total"]
        totalPages <- map["totalPages"]
        data <- map["data"]
    }
}
