//
//  RemoteRespository.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import RxSwift
import Moya

protocol RemoteRepository {
    //Demo
    func getPosts() -> Single<[Post]>
    
    //Auth
    func signIn(userNameOrEmail: String, password: String) -> Single<Result<AuthCredentialDto, ErrorResponse>>
//    func refreshTokenIfNeed() -> Single<Void>
    func resfreshToken(authCredentialDto: AuthCredentialDto) -> Single<Result<AuthCredentialDto, ErrorResponse>>
    func forgotPassword(requestForgetPassword: RequestForgetPasswordDto) -> Single<Moya.Response>
    
    //Profile
    func profile() -> Single<Result<UserInfoDto, ErrorResponse>>
    func getProfileDetail()-> Single<Result<StudentDetailDto, ErrorResponse>>
}
