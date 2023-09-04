//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation

protocol RealmRepresentable {
    associatedtype RealmType: ModelConvertibleType
    
    func asRealm() -> RealmType
}
