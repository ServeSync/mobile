//
//  Post.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import ObjectMapper

struct Post: Mappable {
    var userId: Int = 0
    var id: Int = 0
    var title: String = ""
    var body: String = ""

    init?(map: ObjectMapper.Map) {

    }

    init(userId: Int, id: Int, title: String, body: String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }

    mutating func mapping(map: Map) {
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
    }
}
