//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import Realm
import RealmSwift

protocol ModelConvertibleType {
    associatedtype ModelType
    associatedtype KeyType
    
    var uid: KeyType { get }
    
    func asModel() -> ModelType
}

extension RealmRepresentable {
    static func build<O: Object>(_ builder: (O) -> Void) -> O {
        let object = O()
        builder(object)
        return object
    }
}

