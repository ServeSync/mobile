//
//  SimpleStudentDto.swift
//  PBL6
//
//  Created by KietKoy on 09/12/2023.
//

import Foundation
import ObjectMapper

struct SimpleStudentDto: Mappable {
    var id: String = ""
    var fullName: String = ""
    var imageUrl = ""
    var email = ""
    
    init(id: String, fullName: String, imageUrl: String = "", email: String = "") {
        self.id = id
        self.fullName = fullName
        self.imageUrl = imageUrl
        self.email = email
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        fullName <- map["fullName"]
        imageUrl <- map["imageUrl"]
        email <- map["email"]
    }
}
