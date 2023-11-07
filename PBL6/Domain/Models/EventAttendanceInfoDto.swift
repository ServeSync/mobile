//
//  EventAttendanceInfoDto.swift
//  PBL6
//
//  Created by KietKoy on 24/10/2023.
//

import Foundation
import ObjectMapper

struct EventAttendanceInfoDto: Mappable {
    var id: String = ""
    var code: String = ""
    var qrCodeUrl: String = ""
    var startAt: String = ""
    var endAt: String = ""
    var status: String = ""
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        code        <- map["code"]
        qrCodeUrl   <- map["qrCodeUrl"]
        startAt     <- map["startAt"]
        endAt       <- map["endAt"]
        status      <- map["status"]
    }
}
