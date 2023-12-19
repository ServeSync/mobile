//
//  ProofDtoPagedResultDto.swift
//  PBL6
//
//  Created by KietKoy on 09/12/2023.
//

import Foundation
import ObjectMapper

struct ProofDtoPagedResultDto: Mappable {
    var total: Int = 0
    var totalPages: Int = 0
    var data: [ProofDto] = []
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        total <- map["total"]
        totalPages <- map["totalPages"]
        data <- map["data"]
    }
}
