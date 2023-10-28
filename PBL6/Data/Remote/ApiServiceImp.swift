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
    
    func resfreshToken(authCredentialDto: AuthCredentialDto) -> Single<Result<AuthCredentialDto, ErrorResponse>> {
        return appNetwork.refreshToken(.refreshToken(authCredentialDto: authCredentialDto), errorType: ErrorResponse.self)
    }
    
    func forgetPassword(requestForgetPasswordDto: RequestForgetPasswordDto) -> Single<Moya.Response> {
        return appNetwork.requestWithoutMapping(.forgetPassword(requestForgetPasswordDto: requestForgetPasswordDto))
    }
    
    //MARK: - Profile
    func profileInfo() -> RxSwift.Single<Result<StudentDetailDto, ErrorResponse>> {
        return appNetwork.requestObjectWithTokenRefresh(.profileDetail, successType: StudentDetailDto.self, errorType: ErrorResponse.self)
    }
    
    func profile() -> Single<Result<UserInfoDto, ErrorResponse>> {
        return appNetwork.requestObjectWithTokenRefresh(.profile, successType: UserInfoDto.self, errorType: ErrorResponse.self)
    }
    
    func postImage(image: UIImage) -> RxSwift.Single<Result<ImageResponse, ErrorResponse>> {
        return appNetwork.requestObject(.postImage(image: image), successType: ImageResponse.self, errorType: ErrorResponse.self)
    }
    
    func editProfile(studentEditProfileDto: StudentEditProfileDto) -> RxSwift.Single<Moya.Response> {
        return appNetwork.requestWithoutMappingWithRefreshToken(.putProfile(studentEditProfileDto: studentEditProfileDto))
    }
    
    //MARK: - Event
    
    func getEventsByStatus(status: EventStatus, page: Int = 0) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>> {
        return appNetwork.requestObjectWithTokenRefresh(.getEventsByStatus(status: status, page: page), successType: FlatEventDtoPagedResultDto.self, errorType: ErrorResponse.self)
    }
    
    func getEventById(id: String) -> Single<Result<EventDetailDto, ErrorResponse>> {
        return appNetwork.requestObjectWithTokenRefresh(.getEventById(id: id), successType: EventDetailDto.self, errorType: ErrorResponse.self)
    }
}
