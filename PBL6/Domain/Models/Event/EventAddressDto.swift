//
//  EventAddressDto.swift
//  PBL6
//
//  Created by KietKoy on 15/10/2023.
//

import Foundation
import ObjectMapper

struct EventAddressDto: Mappable {
    var fullAddress: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        fullAddress <- map["fullAddress"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
    }
}
