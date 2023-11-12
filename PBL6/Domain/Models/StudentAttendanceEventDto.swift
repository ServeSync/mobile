//
//  StudentAttendanceEventDto.swift
//  PBL6
//
//  Created by KietKoy on 12/11/2023.
//

import Foundation
import ObjectMapper

struct StudentAttendanceEventDto: Mappable {
    var role: String = ""
    var score: Double = 0
    var attendanceAt: String = ""
    var capacity: Int = 0
    var attended: Int = 0
    var registered: Int = 0
    var approvedRegistered: Int = 0
    var rating: Int = 0
    var activity: EventActivityDto = EventActivityDto()
    var representativeOrganization: BasicOrganizationInEventDto = BasicOrganizationInEventDto()
    var id: String = ""
    var name: String = ""
    var introduction: String = ""
    var imageUrl: String = ""
    var startAt: String = ""
    var endAt: String = ""
    var type: EventType = .Collaboration
    var status: EventStatus = .Approved
    var calculatedStatus: EventStatus = .Approved
    var address: EventAddressDto = EventAddressDto()
    
    init() {}
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        role <- map["role"]
        score <- map["score"]
        attendanceAt <- map["attendanceAt"]
        capacity <- map["capacity"]
        attended <- map["attended"]
        registered <- map["registered"]
        approvedRegistered <- map["approvedRegistered"]
        rating <- map["rating"]
        activity <- map["activity"]
        representativeOrganization <- map["representativeOrganization"]
        id <- map["id"]
        name <- map["name"]
        introduction <- map["introduction"]
        imageUrl <- map["imageUrl"]
        startAt <- map["startAt"]
        endAt <- map["endAt"]
        type <- map["type"]
        status <- map["status"]
        calculatedStatus <- map["calculatedStatus"]
        address <- map["address"]
    }
}
