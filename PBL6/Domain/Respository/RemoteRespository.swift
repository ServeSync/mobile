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
    
    //MARK: - Auth
    func signIn(userNameOrEmail: String, password: String) -> Single<Result<AuthCredentialDto, ErrorResponse>>
    func resfreshToken(authCredentialDto: AuthCredentialDto) -> Single<Result<AuthCredentialDto, ErrorResponse>>
    func forgotPassword(requestForgetPassword: RequestForgetPasswordDto) -> Single<Moya.Response>
    func changePassword(changePassworDto: ChangePassworDto) -> Single<Moya.Response>
    
    //MARK: - Student
    func profile() -> Single<Result<UserInfoDto, ErrorResponse>>
    func getProfileDetail() -> Single<Result<StudentDetailDto, ErrorResponse>>
    func postImage(image: UIImage) -> Single<Result<ImageResponse, ErrorResponse>>
    func editProfile(studentEditProfileDto: StudentEditProfileDto) -> Single<Moya.Response>
    func getEducationProgam() -> Single<Result<StudentEducationProgramDto, ErrorResponse>>
    func getAttendanceEvents(page: Int) -> Single<Result<StudentAttendanceEventDtoPagedResultDto, ErrorResponse>>
    func exportFile(exportStudentAttendanceEventsDto: ExportStudentAttendanceEventsDto) -> Single<Moya.Response>
    
    //MARK: - Event
    func getEventsByStatus(status: EventStatus, page: Int) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>>
    func searchEvent(keyword: String, page: Int) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>>
    func getEventById(id: String) -> Single<Result<EventDetailDto, ErrorResponse>>
    func registerEvent(eventRegisterDto: EventRegisterDto) -> Single<Moya.Response>
    func rollcallEvent(studentAttendEventDto: StudentAttendEventDto, eventId: String) -> Single<Moya.Response>
    
}
