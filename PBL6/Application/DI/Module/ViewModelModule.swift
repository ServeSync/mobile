//
//  ViewModelModule.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import Swinject

final class ViewModelModule{
    
    func register(container: Container) {
        container.register(BaseVM.self) { _ in BaseVM()}
        container.register(HomeVM.self) { _ in HomeVM()}
        container.register(SplashVM.self) { _ in SplashVM()}
    }
}
