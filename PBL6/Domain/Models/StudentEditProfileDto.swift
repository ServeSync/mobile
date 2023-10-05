//
//  StudentEditProfileDto.swift
//  PBL6
//
//  Created by KietKoy on 03/10/2023.
//

import Foundation
import ObjectMapper

struct StudentEditProfileDto: Mappable {
    var email: String = ""
    var phone: String = ""
    var address: String = ""
    var homeTown: String = ""
    var imageUrl: String = ""
    
    init?(map: ObjectMapper.Map) {}
    
    mutating func mapping(map: ObjectMapper.Map) {
        email <-  map["email"]
        phone <- map["phone"]
        address <- map["address"]
        homeTown <- map["homeTown"]
        imageUrl <- map["imageUrl"]
    }
    
    
}
