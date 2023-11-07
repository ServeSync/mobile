//
//  BasicRepresentativeInEventDto.swift
//  PBL6
//
//  Created by KietKoy on 24/10/2023.
//

import Foundation
import ObjectMapper

struct BasicRepresentativeInEventDto: Mappable {
    var id: String = ""
    var name: String = ""
    var imageUrl: String = ""
    var email: String = ""
    var address: String = ""
    var phoneNumber: String = ""
    var position: String = ""
    var role: String = ""
    var organizationRepId: String = ""
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        imageUrl            <- map["imageUrl"]
        email               <- map["email"]
        address             <- map["address"]
        phoneNumber         <- map["phoneNumber"]
        position            <- map["position"]
        role                <- map["role"]
        organizationRepId   <- map["organizationRepId"]
    }
}
