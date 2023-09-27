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
    
    func handleSignIn() -> Observable<SignInStatus> {
        return self.remoteRepository.signIn(userNameOrEmail: userNameOrEmail, password: password)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap { [weak self] result -> Observable<SignInStatus> in
                guard let self = self else { return .just(.Error(message: "self is nil")) }
                switch result {
                case .success(let data):
                    UserDefaultHelper.shared.accessToken = data.accessToken
                    UserDefaultHelper.shared.refreshToken = data.refreshToken
                    return self.remoteRepository.profile().asObservable()
                        .flatMap { [weak self] result -> Observable<SignInStatus> in
                            guard let self = self else { return .just(.Error(message: "self is nil")) }
                            switch result {
                            case .success(let data):
                                if data.roles.contains("student") {
                                    return .just(.Success)
                                } else {
                                    UserDefaultHelper.shared.accessToken = nil
                                    UserDefaultHelper.shared.refreshToken = nil
                                    return .just(.Error(message: "role_error".localized))
                                }
                            case .failure(let error):
                                print("@@@ message \(error.localizedDescription)")
                                return .just(.Error(message: error.localizedDescription))
                            }
                        }
                case .failure(let error):
                    switch error.code {
                    case "User:000002":
                        return .just(.Error(message: "username_or_email_does_not_exist".localized))
                    case "User:000003":
                        return .just(.Error(message: "account_locked_error".localized))
                    case "User:000004":
                        return .just(.Error(message: "incorrect_password".localized))
                    default:
                        print("@@@ message \(error.localizedDescription)")
                        return .just(.Error(message: error.localizedDescription))
                    }
                }
            }
    }
    
}

enum SignInStatus {
    case Success
    case Error(message: String)
}
