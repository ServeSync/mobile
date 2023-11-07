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
        container.register(WelcomeVM.self) { _ in WelcomeVM()}
        container.register(LoginVM.self) { _ in LoginVM()}
        container.register(EventVM.self) { _ in EventVM()}
        container.register(AnalysisVM.self) { _ in AnalysisVM()}
        container.register(AccountVM.self) { _ in AccountVM()}
        container.register(ProfileVM.self) { _ in ProfileVM()}
        container.register(WebviewVM.self) { _ in WebviewVM()}
        container.register(ForgotPasswordVM.self) { _ in ForgotPasswordVM()}
        container.register(EditProfileVM.self) { _ in EditProfileVM()}
        container.register(SeeAllEventVM.self) { _ in SeeAllEventVM()}
        container.register(EventDetailVM.self) { _ in EventDetailVM()}
        container.register(RegisterVM.self) { _ in RegisterVM()}
        container.register(RollCallVM.self) { _ in RollCallVM()}
        container.register(SearchVM.self) { _ in SearchVM()}
    }
}
