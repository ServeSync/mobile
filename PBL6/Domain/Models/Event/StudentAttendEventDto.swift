//
//  StudentAttendEventDto.swift
//  PBL6
//
//  Created by KietKoy on 04/11/2023.
//

import Foundation
import ObjectMapper

struct StudentAttendEventDto: Mappable {
    var code: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    
    init(code: String, latitude: Double, longitude: Double) {
        self.code = code
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
