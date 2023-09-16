//
//  AuthenApiServiceImp.swift
//  PBL6
//
//  Created by KietKoy on 16/09/2023.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

final class AuthenApiServiceImp: AuthenApiService {
    @Inject
    var appNetwork: AppNetwork
    
    func signIn(userNameOrPassword: String, password: String) -> Single<SignInResponse> {
        return appNetwork.requestObject(.signIn(usernameOrEmail: userNameOrPassword, password: password), type: SignInResponse.self)
    }
    
    //MARK: App

    
}

