//
//  InternalProofCreateDto.swift
//  PBL6
//
//  Created by KietKoy on 02/12/2023.
//

import Foundation
import ObjectMapper

struct InternalProofCreateDto: Mappable {
    var eventId: String = ""
    var eventRoleId: String = ""
    var description: String = ""
    var imageUrl: String = ""
    var attendanceAt: String = ""
    
    init(eventId: String, eventRoleId: String, description: String, imageUrl: String, attendanceAt: String) {
        self.eventId = eventId
        self.eventRoleId = eventRoleId
        self.description = description
        self.imageUrl = imageUrl
        self.attendanceAt = attendanceAt
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        eventId         <- map["eventId"]
        eventRoleId     <- map["eventRoleId"]
        description     <- map["description"]
        imageUrl        <- map["imageUrl"]
        attendanceAt    <- map["attendanceAt"]
    }
}
