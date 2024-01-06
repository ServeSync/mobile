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
    
    init(email: String, phone: String, address: String, homeTown: String, imageUrl: String) {
        self.email = email
        self.phone = phone
        self.address = address
        self.homeTown = homeTown
        self.imageUrl = imageUrl
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        email <-  map["email"]
        phone <- map["phone"]
        address <- map["address"]
        homeTown <- map["homeTown"]
        imageUrl <- map["imageUrl"]
    }
    
    
}
