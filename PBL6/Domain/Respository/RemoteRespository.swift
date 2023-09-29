//
//  RemoteRespository.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import RxSwift

protocol RemoteRepository {
    //Demo
    func getPosts() -> Single<[Post]>
    
    //Authen
    func signIn(userNameOrEmail: String, password: String) -> Single<Result<AuthCredentialDto, ErrorResponse>>
//    func refreshTokenIfNeed() -> Single<Void>
    func resfreshToken(authCredentialDto: AuthCredentialDto) -> Single<Result<AuthCredentialDto, ErrorResponse>>
    func profile() -> Single<Result<UserInfoDto, ErrorResponse>>
}
