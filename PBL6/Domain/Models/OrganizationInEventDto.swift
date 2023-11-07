//
//  OrganizationInEventDto.swift
//  PBL6
//
//  Created by KietKoy on 15/10/2023.
//

import Foundation
import ObjectMapper

struct OrganizationInEventDto: Mappable {
    var role: String = ""
    var representatives: [BasicRepresentativeInEventDto] = []
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var address: String = ""
    var imageUrl: String = ""
    var organizationId: String = ""
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        role                <- map["role"]
        representatives     <- map["representatives"]
        id                  <- map["id"]
        name                <- map["name"]
        address                <- map["address"]
        email               <- map["email"]
        phoneNumber         <- map["phoneNumber"]
        imageUrl            <- map["imageUrl"]
        organizationId      <- map["organizationId"]
    }
}
