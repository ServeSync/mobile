//
//  TokenInfo.swift
//  PBL6
//
//  Created by KietKoy on 24/09/2023.
//

import Foundation
import ObjectMapper

struct TokenInfo: Mappable {
    var userId: String = ""
    var userName: String = ""
    var email: String = ""
    var exp: Int = 0
    var referenceId: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        userId <- map["UserId"]
        userName <- map["UserName"]
        email <- map["Email"]
        exp <- map["exp"]
        referenceId <- map["ReferenceId"]
    }
}
