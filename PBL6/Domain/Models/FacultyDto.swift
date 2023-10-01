//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 01/10/2023.
//

import Foundation
import ObjectMapper

struct FacultyDto: Mappable {
    var id: String = ""
    var name: String = ""
    
    init?(map: Map) {}
    
    init(id: String = "", name: String = "") {
        self.id = id
        self.name = name
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
