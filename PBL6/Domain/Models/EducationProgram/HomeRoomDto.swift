//
//  HomeRoomDto.swift
//  PBL6
//
//  Created by KietKoy on 01/10/2023.
//

import Foundation
import ObjectMapper

struct HomeRoomDto: Mappable {
    var id: String = ""
    var name: String = ""
    var falcultyId: String = ""
    
    init?(map: Map) {}
    
    init(id: String = "", name: String = "", falcultyId: String = "") {
        self.id = id
        self.name = name
        self.falcultyId = falcultyId
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        falcultyId <- map["falcultyId"]
    }
}
