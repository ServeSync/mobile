//
//   BasicOrganizationInEventDto.swift
//  PBL6
//
//  Created by KietKoy on 24/10/2023.
//

import Foundation
import ObjectMapper

struct BasicOrganizationInEventDto: Mappable {
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
        id                  <- map["id"]
        name                <- map["name"]
        imageUrl            <- map["imageUrl"]
        organizationId      <- map["organizationId"]
        email               <- map["email"]
        phoneNumber         <- map["phoneNumber"]
        address             <- map["address"]
    }
}
