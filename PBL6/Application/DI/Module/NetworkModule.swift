//
//  NetworkModule.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import Swinject
import Realm
import RealmSwift

final class NetworkModule {
    
    func register(container: Container) {
        container.register(AppNetwork.self) { _ in AppNetworkImp() }
        container.register(ApiService.self) { _ in ApiServiceImp() }
    }
    
}
