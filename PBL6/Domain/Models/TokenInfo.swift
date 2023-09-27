//
//  TokenInfo.swift
//  PBL6
//
//  Created by KietKoy on 24/09/2023.
//

import Foundation
import ObjectMapper

struct TokenInfo: Mappable {
    var userID: String = ""
    var userName: String = ""
    var email: String = ""
    var exp: Int = 0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        userID <- map["UserId"]
        userName <- map["UserName"]
        email <- map["email"]
        exp <- map["exp"]
    }
}
