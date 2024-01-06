//
//  RegisteredStudentInEventDtoPagedResultDto.swift
//  PBL6
//
//  Created by KietKoy on 02/12/2023.
//

import Foundation
import ObjectMapper

struct RegisteredStudentInEventDtoPagedResultDto: Mappable {
    var total: Int = 0
    var totalPages: Int = 0
    var data: [RegisteredStudentInEventDto] = []
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        total       <- map["total"]
        totalPages  <- map["totalPages"]
        data        <- map["data"]
    }
}
