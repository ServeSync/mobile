//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import RxSwift
import Moya

final class RemoteRepositoryImp: RemoteRepository {

    @Inject
    var apiService: ApiService!
    
    func getPosts() -> Single<[Post]> {
        return apiService.getPost()
    }
    
    //Authen
    func signIn(userNameOrEmail: String, password: String) -> Single<Result<AuthCredentialDto, ErrorResponse>> {
        return apiService.signIn(userNameOrPassword: userNameOrEmail, password: password)
    }
    
//    func refreshTokenIfNeed() -> Single<Void> {
//        return apiService.refreshTokenIfNeed()
//    }
    
    func resfreshToken(authCredentialDto: AuthCredentialDto) -> Single<Result<AuthCredentialDto, ErrorResponse>> {
        return apiService.resfreshToken(authCredentialDto: authCredentialDto)
    }
    
    func forgotPassword(requestForgetPassword: RequestForgetPasswordDto) -> Single<Moya.Response> {
        return apiService.forgetPassword(requestForgetPasswordDto: requestForgetPassword)
    }
    
    //Profile
    func getProfileDetail() -> Single<Result<StudentDetailDto, ErrorResponse>> {
        return apiService.profileInfo()
    }
    
    func profile() -> Single<Result<UserInfoDto, ErrorResponse>> {
        return apiService.profile()
    }
}
