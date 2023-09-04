//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import Realm
import RealmSwift

private let dbVersion : UInt64 = 1
private let dbName = "base_project"

final class DBManager {
    
    var config: Realm.Configuration!
    
    init() {
        
        config = Realm.Configuration(
            schemaVersion: dbVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    //MARK: migrate db here
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
}

