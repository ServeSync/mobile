//
//  StudentEducationProgramDto.swift
//  PBL6
//
//  Created by KietKoy on 12/11/2023.
//

import Foundation
import ObjectMapper

struct StudentEducationProgramDto: Mappable {
    var gainScore: Double = 0
    var numberOfEvents: Int = 0
    var id: String = ""
    var name: String = ""
    var requiredActivityScore: Int = 0
    var requiredCredit: Int = 0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        gainScore               <- map["gainScore"]
        numberOfEvents          <- map["numberOfEvents"]
        id                      <- map["id"]
        name                    <- map["name"]
        requiredActivityScore   <- map["requiredActivityScore"]
        requiredCredit          <- map["requiredCredit"]
    }
}
