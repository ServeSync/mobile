//
//  EventRegistrationDto.swift
//  PBL6
//
//  Created by KietKoy on 24/10/2023.
//

import Foundation
import ObjectMapper

struct EventRegistrationDto: Mappable {
    var id: String = ""
    var startAt: String = ""
    var endAt: String = ""
    var status: String = ""
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        startAt <- map["startAt"]
        endAt <- map["endAt"]
        status <- map["status"]
    }
}
