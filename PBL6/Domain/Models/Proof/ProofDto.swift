//
//  ProofDto.swift
//  PBL6
//
//  Created by KietKoy on 09/12/2023.
//

import Foundation
import ObjectMapper

struct ProofDto: Mappable {
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
    
    init(id: String, proofStatus: String, proofType: String, eventName: String, organizationName: String, role: String, address: String, imageUrl: String, score: Double, student: SimpleStudentDto, activity: EventActivityDto, startAt: String, endAt: String, attendanceAt: String, created: String, lastModified: String) {
        self.id = id
        self.proofStatus = proofStatus
        self.proofType = proofType
        self.eventName = eventName
        self.organizationName = organizationName
        self.role = role
        self.address = address
        self.imageUrl = imageUrl
        self.score = score
        self.student = student
        self.activity = activity
        self.startAt = startAt
        self.endAt = endAt
        self.attendanceAt = attendanceAt
        self.created = created
        self.lastModified = lastModified
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id                  <- map["id"]
        proofStatus         <- map["proofStatus"]
        proofType           <- map["proofType"]
        eventName           <- map["eventName"]
        organizationName    <- map["organizationName"]
        role                <- map["role"]
        address             <- map["address"]
        imageUrl            <- map["imageUrl"]
        score               <- map["score"]
        student             <- map["student"]
        activity            <- map["activity"]
        startAt             <- map["startAt"]
        endAt               <- map["endAt"]
        attendanceAt        <- map["attendanceAt"]
        created             <- map["created"]
        lastModified        <- map["lastModified"]
    }
}
