//
//  OrganizationInEventDto.swift
//  PBL6
//
//  Created by KietKoy on 15/10/2023.
//

import Foundation
import ObjectMapper

struct OrganizationInEventDto: Mappable {
    var id: String = ""
    var name: String = ""
    var imageUrl: String = ""
    
    init() {}
    
    init(id: String, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        
    }
}
