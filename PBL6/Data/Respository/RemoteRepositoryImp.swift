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
    
    //MARK: - Authen
    func signIn(userNameOrEmail: String, password: String) -> Single<Result<AuthCredentialDto, ErrorResponse>> {
        return apiService.signIn(userNameOrPassword: userNameOrEmail, password: password)
    }
    
    func resfreshToken(authCredentialDto: AuthCredentialDto) -> Single<Result<AuthCredentialDto, ErrorResponse>> {
        return apiService.resfreshToken(authCredentialDto: authCredentialDto)
    }
    
    func forgotPassword(requestForgetPassword: RequestForgetPasswordDto) -> Single<Moya.Response> {
        return apiService.forgetPassword(requestForgetPasswordDto: requestForgetPassword)
    }
    
    //MARK: - Profile
    func getProfileDetail() -> Single<Result<StudentDetailDto, ErrorResponse>> {
        return apiService.profileInfo()
    }
    
    func profile() -> Single<Result<UserInfoDto, ErrorResponse>> {
        return apiService.profile()
    }
    
    func postImage(image: UIImage) -> RxSwift.Single<Result<ImageResponse, ErrorResponse>> {
        return apiService.postImage(image: image)
    }
    
    func editProfile(studentEditProfileDto: StudentEditProfileDto) -> RxSwift.Single<Moya.Response> {
        return apiService.editProfile(studentEditProfileDto: studentEditProfileDto)
    }
    
    //MARK: - Event
    
    func getEventsByStatus(status: EventStatus, page: Int = 0) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>> {
        return apiService.getEventsByStatus(status: status, page: page)
    }
    
    func getEventById(id: String) -> RxSwift.Single<Result<EventDetailDto, ErrorResponse>> {
        return apiService.getEventById(id: id)
    }
}
