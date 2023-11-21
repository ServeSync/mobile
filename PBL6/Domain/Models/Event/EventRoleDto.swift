//
//  EventRoleDto.swift
//  PBL6
//
//  Created by KietKoy on 24/10/2023.
//

import Foundation
import ObjectMapper

struct EventRoleDto: Mappable {
    var isRegistered: Bool = false
    var registered: Int = 0
    var approvedRegistered: Int = 0
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var isNeedApprove: Bool = false
    var score: Double = 0.0
    var quantity: Int = 0
    var isSelected = false
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        isRegistered            <- map["isRegistered"]
        registered              <- map["registered"]
        approvedRegistered      <- map["approvedRegistered"]
        id                      <- map["id"]
        name                    <- map["name"]
        description             <- map["description"]
        isNeedApprove           <- map["isNeedApprove"]
        score                   <- map["score"]
        quantity                <- map["quantity"]
    }
}
