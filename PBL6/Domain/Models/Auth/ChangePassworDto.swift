//
//  ChangePassworđto.swift
//  PBL6
//
//  Created by KietKoy on 21/11/2023.
//

import Foundation
import ObjectMapper

struct ChangePassworDto: Mappable {
    var currentPassword: String = ""
    var newPassword: String = ""
    
    init(currentPassword: String, newPassword: String) {
        self.currentPassword = currentPassword
        self.newPassword = newPassword
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        currentPassword <- map["currentPassword"]
        newPassword     <- map["newPassword"]
    }
}
