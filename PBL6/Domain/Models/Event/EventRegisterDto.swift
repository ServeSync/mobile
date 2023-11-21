//
//  EventRegisterDto.swift
//  PBL6
//
//  Created by KietKoy on 04/11/2023.
//

import Foundation
import ObjectMapper

struct EventRegisterDto: Mappable {
    var eventRoleId: String = ""
    var description: String = ""
    
    init(eventRoleId: String, description: String) {
        self.eventRoleId = eventRoleId
        self.description = description
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        eventRoleId <- map["eventRoleId"]
        description <- map["description"]
    }
}
