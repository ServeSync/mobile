//
//  UserInfoDto.swift
//  PBL6
//
//  Created by KietKoy on 23/09/2023.
//

import Foundation
import ObjectMapper

struct UserInfoDto: Mappable {
    var id: String = ""
    var email: String = ""
    var roles: [String] = []
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id      <- map["id"]
        email   <- map["email"]
        roles   <- map["roles"]
    }
}
