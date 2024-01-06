//
//  StudentDetailDto.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import Foundation
import ObjectMapper

struct StudentDetailDto: Mappable {
    var id: String = ""
    var code: String = ""
    var fullName: String = ""
    var gender: Bool = false
    var dateOfBirth: String = ""
    var homeTown: String = ""
    var address: String = ""
    var imageUrl: String = ""
    var citizenId: String = ""
    var email: String = ""
    var phone: String = ""
    var identityId: String = ""
    var faculty: FacultyDto = FacultyDto()
    var homeRoom: HomeRoomDto = HomeRoomDto()
    var educationProgram: EducationProgramDto = EducationProgramDto()
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id                  <- map["id"]
        code                <- map["code"]
        fullName            <- map["fullName"]
        gender              <- map["gender"]
        dateOfBirth         <- map["dateOfBirth"]
        homeTown            <- map["homeTown"]
        address             <- map["address"]
        imageUrl            <- map["imageUrl"]
        citizenId           <- map["citizenId"]
        email               <- map["email"]
        phone               <- map["phone"]
        identityId          <- map["identityId"]
        faculty             <- map["faculty"]
        homeRoom            <- map["homeRoom"]
        educationProgram    <- map["educationProgram"]
    }
    
    
}
