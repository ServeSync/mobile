//
//  FlatEventDto.swift
//  PBL6
//
//  Created by KietKoy on 15/10/2023.
//

import Foundation
import ObjectMapper

struct FlatEventDto: Mappable {
    var capacity: Int = 0
    var registered: Int = 0
    var rating: Int = 0
    var representativeOrganization: OrganizationInEventDto = OrganizationInEventDto()
    var id: String = ""
    var name: String = ""
    var introduction: String = ""
    var imageUrl: String = ""
    var startAt: String = ""
    var endAt: String = ""
    var type: String = ""
    var status: String = ""
    var address: EventAddressDto = EventAddressDto()
    
    init() {}
    
    init(capacity: Int, registered: Int, rating: Int, representativeOrganization: OrganizationInEventDto, id: String, name: String, introduction: String, imageUrl: String, startAt: String, endAt: String, type: String, status: String, address: EventAddressDto) {
        self.capacity = capacity
        self.registered = registered
        self.rating = rating
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
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        capacity <- map["capacity"]
        registered <- map["registered"]
        rating <- map["rating"]
        representativeOrganization <- map["representativeOrganization"]
        id <- map["id"]
        name <- map["name"]
        introduction <- map["introduction"]
        imageUrl <- map["imageUrl"]
        startAt <- map["startAt"]
        endAt <- map["endAt"]
        type <- map["type"]
        status <- map["status"]
        address <- map["address"]
    }
}
