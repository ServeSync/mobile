//
//  Resolver.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Swinject

extension Resolver {
    public func resolve<T>() -> T {
        guard let resolvedType = resolve(T.self) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        
        return resolvedType
    }
}
