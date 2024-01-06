//
//  ExternalProofCreateDto.swift
//  PBL6
//
//  Created by KietKoy on 02/12/2023.
//

import Foundation
import ObjectMapper

struct ExternalProofCreateDto: Mappable {
    var eventName: String = ""
    var address: String = ""
    var organizationName: String = ""
    var role: String = ""
    var score: Double = 0
    var attendanceAt: String = ""
    var startAt: String = ""
    var endAt: String = ""
    var activityId: String = ""
    var description: String = ""
    var imageUrl: String = ""
    
    init() {}
    
    init?(map: Map) {}
    
    init(eventName: String,
         address: String,
         organizationName: String,
         role: String, 
         score: Double,
         attendanceAt: String,
         startAt: String, 
         endAt: String,
         activityId: String,
         description: String,
         imageUrl: String) {
        self.eventName = eventName
        self.address = address
        self.organizationName = organizationName
        self.role = role
        self.score = score
        self.attendanceAt = attendanceAt
        self.startAt = startAt
        self.endAt = endAt
        self.activityId = activityId
        self.description = description
        self.imageUrl = imageUrl
    }
    
    mutating func mapping(map: Map) {
        eventName <- map["eventName"]
        address <- map["address"]
        organizationName <- map["organizationName"]
        role <- map["role"]
        attendanceAt <- map["attendanceAt"]
        startAt <- map["startAt"]
        endAt <- map["endAt"]
        activityId <- map["activityId"]
        description <- map["description"]
        imageUrl <- map["imageUrl"]
    }
}
