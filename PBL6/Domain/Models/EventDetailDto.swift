//
//  EventDetailDto.swift
//  PBL6
//
//  Created by KietKoy on 24/10/2023.
//

import Foundation
import ObjectMapper

struct EventDetailDto: Mappable {
    var isRegistered: Bool = false
    var isAttendance: Bool = false
    var roles: [EventRoleDto] = []
    var organizations: [OrganizationInEventDto] = []
    var registrationInfos: [EventRegistrationDto] = []
    var attendanceInfos: [EventAttendanceInfoDto] = []
    var capacity: Int = 0
    var registered: Int = 0
    var rating: Int = 0
    var activity: BasicEventActivityDto = BasicEventActivityDto()
    var representativeOrganization: BasicOrganizationInEventDto = BasicOrganizationInEventDto()
    var id: String = ""
    var name: String = ""
    var introduction: String = ""
    var imageUrl: String = ""
    var startAt: String = ""
    var endAt: String = ""
    var type: String = ""
    var status: String = ""
    var address: EventAddressDto = EventAddressDto()
    
    
    init(isRegistered: Bool, isAttendance: Bool, roles: [EventRoleDto], organizations: [OrganizationInEventDto], registrationInfos: [EventRegistrationDto], attendanceInfos: [EventAttendanceInfoDto], capacity: Int, registered: Int, rating: Int, activity: BasicEventActivityDto, representativeOrganization: BasicOrganizationInEventDto, id: String, name: String, introduction: String, imageUrl: String, startAt: String, endAt: String, type: String, status: String, address: EventAddressDto) {
        self.isRegistered = isRegistered
        self.isAttendance = isAttendance
        self.roles = roles
        self.organizations = organizations
        self.registrationInfos = registrationInfos
        self.attendanceInfos = attendanceInfos
        self.capacity = capacity
        self.registered = registered
        self.rating = rating
        self.activity = activity
        self.representativeOrganization = representativeOrganization
        self.id = id
        self.name = name
        self.introduction = introduction
        self.imageUrl = imageUrl
        self.startAt = startAt
        self.endAt = endAt
        self.type = type
        self.status = status
        self.address = address
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        isRegistered                <- map["isRegistered"]
        isAttendance                <- map["isAttendance"]
        roles                       <- map["roles"]
        organizations               <- map["organizations"]
        registrationInfos           <- map["registrationInfos"]
        attendanceInfos             <- map["attendanceInfos"]
        capacity                    <- map["capacity"]
        registered                  <- map["registered"]
        rating                      <- map["rating"]
        activity                    <- map["activity"]
        representativeOrganization  <- map["representativeOrganization"]
        id                          <- map["id"]
        name                        <- map["name"]
        introduction                <- map["introduction"]
        imageUrl                    <- map["imageUrl"]
        startAt                     <- map["startAt"]
        endAt                       <- map["endAt"]
        type                        <- map["type"]
        status                      <- map["status"]
        address                     <- map["address"]
    }
}
