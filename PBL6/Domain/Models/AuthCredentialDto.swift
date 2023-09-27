//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 16/09/2023.
//

import ObjectMapper

struct AuthCredentialDto: Mappable, Encodable {
    var accessToken: String = ""
    var refreshToken: String = ""
    
    init?(map: Map) {}
    
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    mutating func mapping(map: Map) {
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
    }
}
