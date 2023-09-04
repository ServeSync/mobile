//
//  DataBaseModule.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import Swinject
import Realm
import RealmSwift

final class DatabaseModule {
    
    func register(container: Container, config: Realm.Configuration!) {
        container.register(PostDAO.self) { _ in PostDAOImp(config: config) }
    }
    
}
