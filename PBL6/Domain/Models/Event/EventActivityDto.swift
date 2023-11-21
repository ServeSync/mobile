//
//  EventActivityDto.swift
//  PBL6
//
//  Created by KietKoy on 12/11/2023.
//

import Foundation
import ObjectMapper

struct EventActivityDto: Mappable {
    var minScore: Double = 0
    var maxScore: Double = 0
    var eventCategoryId: String = ""
    var id: String = ""
    var name: String = ""
    
    init() {}
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        minScore        <- map["minScore"]
        maxScore        <- map["maxScore"]
        eventCategoryId <- map["eventCategoryId"]
        id              <- map["id"]
        name            <- map["name"]
    }
}
