//
//  LoginVM.swift
//  PBL6
//
//  Created by KietKoy on 16/09/2023.
//

import Foundation
import RxSwift
import RxRelay

class LoginVM: BaseVM {
    var userNameOrEmail: String = ""
    var password: String = ""
    
    let enableLoginRelay = PublishRelay<Bool>()
    
    override init() {
        super.init()
        
        UserDefaultHelper.shared.accessToken = nil
        UserDefaultHelper.shared.refreshToken = nil
    }
    
    func handleSignIn() -> Observable<HandleStatus> {
        return self.remoteRepository.signIn(userNameOrEmail: userNameOrEmail, password: password)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap { [weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil)) }
                switch result {
                case .success(let data):
                    UserDefaultHelper.shared.accessToken = data.accessToken
                    UserDefaultHelper.shared.refreshToken = data.refreshToken
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
}

