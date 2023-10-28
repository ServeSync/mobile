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
    var position: String = ""
    var role: String = ""
    var organizationRepId: String = ""
    
    
    init(id: String, name: String, imageUrl: String, position: String, role: String, organizationRepId: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.position = position
        self.role = role
        self.organizationRepId = organizationRepId
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        position <- map["position"]
        role <- map["role"]
        organizationRepId <- map["organizationRepId"]
    }
}
