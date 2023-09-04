//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import ObjectMapper

struct PostResponse: Mappable {
    
    var data: [Post] = []
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
    
}
