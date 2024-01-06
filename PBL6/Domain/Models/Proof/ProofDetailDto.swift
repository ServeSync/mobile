//
//  ProofDetailDto.swift
//  PBL6
//
//  Created by KietKoy on 09/12/2023.
//

import Foundation
import ObjectMapper

struct ProofDetailDto: Mappable {
    var eventId: String = ""
    var description: String = ""
    var rejectReason: String = ""
    var id: String = ""
    var proofStatus: String = ""
    var proofType: String = ""
    var eventName: String = ""
    var organizationName: String = ""
    var role: String = ""
    var address: String = ""
    var imageUrl: String = ""
    var score: Double = 0
    var student: SimpleStudentDto = SimpleStudentDto()
    var activity: EventActivityDto = EventActivityDto()
    var startAt: String = ""
    var endAt: String = ""
    var attendanceAt: String = ""
    var created: String = ""
    var lastModified: String = ""
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        eventId <- map["eventId"]
        description <- map["description"]
        rejectReason <- map["rejectReason"]
        id <- map["id"]
        proofStatus <- map["proofStatus"]
        proofType <- map["proofType"]
        eventName <- map["eventName"]
        organizationName <- map["organizationName"]
        role <- map["role"]
        address <- map["address"]
        imageUrl <- map["imageUrl"]
        score <- map["score"]
        student <- map["student"]
        activity <- map["activity"]
        startAt <- map["startAt"]
        endAt <- map["endAt"]
        attendanceAt <- map["attendanceAt"]
        created <- map["created"]
        lastModified <- map["lastModified"]
    }
}
