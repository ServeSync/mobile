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
    var imageUrl: String = ""
    var organizationId: String = ""
    
    init(id: String, name: String, imgUrl: String, organizationId: String) {
        self.id = id
        self.name = name
        self.imageUrl = imgUrl
        self.organizationId = organizationId
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        imageUrl            <- map["imageUrl"]
        organizationId      <- map["organizationId"]
    }
}
