//
//  RespositoryModule.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import Swinject

final class RepositoryModule {
    
    func register(container: Container) {
        container.register(LocalRespository.self) { _ in LocalRespositoryImp() }
        container.register(RemoteRepository.self) { _ in RemoteRepositoryImp() }
    }
}
