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
    var rejectReason: String = ""
    
    init() {}
    
    init?(map: Map) {}
    
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
        rejectReason <- map["rejectReason"]
    }
}
