//
//  REvent.swift
//  PBL6
//
//  Created by KietKoy on 28/10/2023.
//

import Foundation
import RealmSwift
import Realm

class REvent: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension REvent: ModelConvertibleType {
    var uid: String {
        return String(id)
    }
    
    func asModel() -> EventDetailDto {
        return EventDetailDto()
    }
}

extension EventDetailDto: RealmRepresentable {
    typealias RealmType = REvent
    
    func asRealm() -> REvent {
        return EventDetailDto.build {
            $0.id = id
            $0.name = name
        }
    }
}
