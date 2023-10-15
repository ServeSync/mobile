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
    var longitude: String = ""
    var latitude: String = ""
    
    init() {}
    
    init(fullAddress: String, longitude: String, latitude: String) {
        self.fullAddress = fullAddress
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        fullAddress <- map["fullAddress"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
    }
}
