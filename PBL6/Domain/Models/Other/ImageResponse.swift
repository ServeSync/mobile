//
//  ImageResponse.swift
//  PBL6
//
//  Created by KietKoy on 05/10/2023.
//

import Foundation
import ObjectMapper

struct ImageResponse: Mappable {
    var url: String = ""
    
    init(url: String) {
        self.url = url
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        url <- map["url"]
    }
}
