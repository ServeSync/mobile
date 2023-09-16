//
//  LoginResponse.swift
//  PBL6
//
//  Created by KietKoy on 16/09/2023.
//

import ObjectMapper

struct SignInResponse: Mappable {
    var accessToken: String = ""
    var refreshToken: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
    }
}
