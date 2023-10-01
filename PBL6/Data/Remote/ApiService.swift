//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Foundation
import RxSwift
import Moya

protocol ApiService {
    func getPost() -> Single<[Post]>
    
    //Authen
    func signIn(userNameOrPassword: String, password: String) -> Single<Result<AuthCredentialDto, ErrorResponse>>
    func profile() -> Single<Result<UserInfoDto, ErrorResponse>>
//    func refreshTokenIfNeed() -> Single<Void>
    func resfreshToken(authCredentialDto: AuthCredentialDto) -> Single<Result<AuthCredentialDto, ErrorResponse>>
    func forgetPassword(requestForgetPasswordDto: RequestForgetPasswordDto) -> Single<Moya.Response>
    
    //Profile
    
//    func profileInfo() -> Single<Result<
}
