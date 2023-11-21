//
//  FlatEventDtoPagedResultDto.swift
//  PBL6
//
//  Created by KietKoy on 15/10/2023.
//

import Foundation
import ObjectMapper

struct FlatEventDtoPagedResultDto: Mappable {
    var total: Int = 0
    var totalPages: Int = 0
    var data: [FlatEventDto] = []
    
    init(total: Int, totalPages: Int) {
        self.total = total
        self.totalPages = totalPages
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        total <- map["total"]
        totalPages <- map["totalPages"]
        data <- map["data"]
    }
}
