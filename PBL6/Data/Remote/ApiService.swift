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
    
    //MARK: - Authen
    func signIn(userNameOrPassword: String, password: String) -> Single<Result<AuthCredentialDto, ErrorResponse>>
    func resfreshToken(authCredentialDto: AuthCredentialDto) -> Single<Result<AuthCredentialDto, ErrorResponse>>
    func forgetPassword(requestForgetPasswordDto: RequestForgetPasswordDto) -> Single<Moya.Response>
    
    //MARK: - Event
    func profile() -> Single<Result<UserInfoDto, ErrorResponse>>
    func profileInfo() -> Single<Result<StudentDetailDto, ErrorResponse>>
    func postImage(image: UIImage) -> Single<Result<ImageResponse, ErrorResponse>>
    func editProfile(studentEditProfileDto: StudentEditProfileDto) -> Single<Moya.Response>
    
    //MARK: - Event
    func getEventsByStatus(status: EventStatus, page: Int) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>>
}
