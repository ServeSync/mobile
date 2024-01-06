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
    @objc dynamic var startAt: String = ""
    @objc dynamic var endAt: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var imageUrl: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension REvent: ModelConvertibleType {
    var uid: String {
        return String(id)
    }
    
    func asModel() -> FlatEventDto {
        return FlatEventDto(id: id,
                              name: name,
                              startAt: startAt,
                              endAt: endAt,
                              address: address,
                              imageUrl: imageUrl
        )
    }
}

extension FlatEventDto: RealmRepresentable {
    typealias RealmType = REvent
    
    func asRealm() -> REvent {
        return FlatEventDto.build {
            $0.id = id
            $0.name = name
            $0.startAt = startAt
            $0.endAt = endAt
            $0.address = address.fullAddress
            $0.imageUrl = imageUrl
        }
    }
}

extension EventDetailDto {
    func asFlatEventDto() -> FlatEventDto {
        return FlatEventDto(id: self.id, 
                            name: self.name,
                            startAt: self.startAt,
                            endAt: self.endAt,
                            address: self.address.fullAddress,
                            imageUrl: self.imageUrl)
    }
}
