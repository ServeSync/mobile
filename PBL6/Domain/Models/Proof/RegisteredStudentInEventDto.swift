//
//  RegisteredStudentInEventDtoRegisteredStudentInEventDto.swift
//  PBL6
//
//  Created by KietKoy on 02/12/2023.
//

import Foundation
import ObjectMapper

struct RegisteredStudentInEventDto: Mappable {
    var role: String = ""
    var id: String = ""
    var studentId: String = ""
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var description: String = ""
    var rejectReason: String = ""
    var status: String = ""
    var imageUrl: String = ""
    var homeRoomName: String = ""
    var registeredAt: String = ""

    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        role            <- map["role"]
        id              <- map["id"]
        studentId       <- map["studentId"]
        name            <- map["name"]
        email           <- map["email"]
        phone           <- map["phone"]
        description     <- map["description"]
        rejectReason    <- map["rejectReason"]
        status          <- map["status"]
        imageUrl        <- map["imageUrl"]
        homeRoomName    <- map["homeRoomName"]
        registeredAt    <- map["registeredAt"]
    }
}
