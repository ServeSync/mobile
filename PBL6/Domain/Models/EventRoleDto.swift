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
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var isNeedApprove: Bool = false
    var score: Double = 0.0
    var quantity: Int = 0
    
    init(isRegistered: Bool, registered: Int, id: String, name: String, description: String, isNeedApprove: Bool, score: Double, quantity: Int) {
        self.isRegistered = isRegistered
        self.registered = registered
        self.id = id
        self.name = name
        self.description = description
        self.isNeedApprove = isNeedApprove
        self.score = score
        self.quantity = quantity
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        isRegistered <- map["isRegistered"]
        registered <- map["registered"]
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        isNeedApprove <- map["isNeedApprove"]
        score <- map["score"]
        quantity <- map["quantity"]
    }
}
