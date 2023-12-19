//
//  SpecialProofCreateDto.swift
//  PBL6
//
//  Created by KietKoy on 04/12/2023.
//

import Foundation
import ObjectMapper

struct SpecialProofCreateDto: Mappable {
    var title: String = ""
    var role: String = ""
    var score: Double = 0
    var startAt: String = ""
    var endAt: String = ""
    var activityId: String = ""
    var description: String = ""
    var imageUrl: String = ""
    
    init() {}
    
    init?(map: Map) {}
    
    init(title: String, role: String, score: Double, startAt: String, endAt: String, activityId: String, description: String, imageUrl: String) {
        self.title = title
        self.role = role
        self.score = score
        self.startAt = startAt
        self.endAt = endAt
        self.activityId = activityId
        self.description = description
        self.imageUrl = imageUrl
    }
    
    mutating func mapping(map: Map) {
        title       <- map["title"]
        role        <- map["role"]
        score       <- map["score"]
        startAt     <- map["startAt"]
        endAt       <- map["endAt"]
        activityId  <- map["activityId"]
        description <- map["description"]
        imageUrl    <- map["imageUrl"]
    }
}
