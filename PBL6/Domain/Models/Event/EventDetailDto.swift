//
//  EventDetailDto.swift
//  PBL6
//
//  Created by KietKoy on 24/10/2023.
//

import Foundation
import ObjectMapper

struct EventDetailDto: Mappable {
    var description: String = ""
    var isRegistered: Bool = false
    var isAttendance: Bool = false
    var roles: [EventRoleDto] = []
    var organizations: [OrganizationInEventDto] = []
    var registrationInfos: [EventRegistrationDto] = []
    var attendanceInfos: [EventAttendanceInfoDto] = []
    var capacity: Int = 0
    var attended: Int = 0
    var registered: Int = 0
    var approvedRegistered: Int = 0
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
    var calculatedStatus: String = ""
    var address: EventAddressDto = EventAddressDto()
    var isFavorite: Bool = false
    
    init(id: String, name: String, startAt: String, endAt: String, address: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.startAt = startAt
        self.endAt = endAt
        self.address.fullAddress = address
        self.imageUrl = imageUrl
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        description                 <- map["description"]
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
        attended                    <- map["attended"]
        approvedRegistered          <- map["approvedRegistered"]
        calculatedStatus            <- map["calculatedStatus"]
    }
}
