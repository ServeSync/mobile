//
//  Error.swift
//  PBL6
//
//  Created by KietKoy on 23/09/2023.
//

import Foundation
import ObjectMapper

struct ErrorResponse: Mappable, LocalizedError {
    var code: String = ""
    var message: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
    }
    var errorDescription: String? {
        return message
    }
}
