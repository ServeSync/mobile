//
//  EducationProgramDto.swift
//  PBL6
//
//  Created by KietKoy on 01/10/2023.
//

import Foundation
import ObjectMapper

struct EducationProgramDto: Mappable {
    var id: String = ""
    var name: String = ""
    var requiredActivityScore: Int = 0
    var requiredCredit: Int = 0
    
    init?(map: Map) {}
    
    init(id: String = "", 
         name: String = "",
         requiredActivityScore: Int = 0,
         requiredCredit: Int = 0) {
        self.id = id
        self.name = name
        self.requiredActivityScore = requiredActivityScore
        self.requiredCredit = requiredCredit
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        requiredActivityScore <- map["requiredActivityScore"]
        requiredCredit <- map["requiredCredit"]
    }
}
