//
//  BasicEventActivityDto.swift
//  PBL6
//
//  Created by KietKoy on 24/10/2023.
//

import Foundation
import ObjectMapper

struct BasicEventActivityDto: Mappable {
    var id: String = ""
    var name: String = ""
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id      <- map["id"]
        name    <- map["name"]
    }
}
