//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

final class ApiServiceImp: ApiService {
    
    @Inject
    var appNetwork: AppNetwork
    
    //MARK: -- Demo
    
    func getPost() -> Single<[Post]> {
        return appNetwork.requestArray(.posts, type: Post.self)
    }
    
    //MARK: Authen
    
    func signIn(userNameOrPassword: String, password: String) -> Single<Result<AuthCredentialDto, ErrorResponse>> {
        return appNetwork.requestObject(.signIn(usernameOrEmail: userNameOrPassword, password: password), successType: AuthCredentialDto.self, errorType: ErrorResponse.self )
    }
    
    func refreshTokenIfNeed() -> Single<Void> {
        return appNetwork.refreshTokenIfNeeded()
    }
    
    func profile() -> Single<Result<UserInfoDto, ErrorResponse>> {
        return appNetwork.requestObjectWithTokenRefresh(.profile, successType: UserInfoDto.self, errorType: ErrorResponse.self)
    }
}
