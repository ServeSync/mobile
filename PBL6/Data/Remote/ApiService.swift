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
    
    //MARK: - Authen
    func signIn(userNameOrPassword: String, password: String) -> Single<Result<AuthCredentialDto, ErrorResponse>>
    func resfreshToken(authCredentialDto: AuthCredentialDto) -> Single<Result<AuthCredentialDto, ErrorResponse>>
    func forgetPassword(requestForgetPasswordDto: RequestForgetPasswordDto) -> Single<Moya.Response>
    func changePassword(changePassworDto: ChangePassworDto) -> Single<Moya.Response>
    
    //MARK: - Student
    func profile() -> Single<Result<UserInfoDto, ErrorResponse>>
    func profileInfo() -> Single<Result<StudentDetailDto, ErrorResponse>>
    func postImage(image: UIImage) -> Single<Result<ImageResponse, ErrorResponse>>
    func editProfile(studentEditProfileDto: StudentEditProfileDto) -> Single<Moya.Response>
    func getEducationProgam() -> Single<Result<StudentEducationProgramDto, ErrorResponse>>
    func getAttendanceEvents() -> Single<Result<StudentAttendanceEventDtoPagedResultDto, ErrorResponse>>
    func exportFile(exportStudentAttendanceEventsDto: ExportStudentAttendanceEventsDto) -> Single<Moya.Response>
    
    //MARK: - Event
    func getEventsByStatus(status: EventStatus, page: Int) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>>
    func searchEvent(keyword: String, page: Int) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>>
    func getEventById(id: String) -> Single<Result<EventDetailDto, ErrorResponse>>
    func registerEvent(eventRegisterDto: EventRegisterDto) -> Single<Moya.Response>
    func rollcallEvent(studentAttendEventDto: StudentAttendEventDto, eventId: String) -> Single<Moya.Response>
    func getEventRegistered(studentId: String) -> Single<Result<StudentRegisteredEventDtoPagedResultDto, ErrorResponse>>
    func getAllYourEvents() -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>>
    func getEventActivities(type: EventActivityType) -> Single<Result<[EventActivityDto], ErrorResponse>>
    func getEventForSelf(status: EventStatus) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>>
    
    //MARK: - Proof
    func postProofInternal(internalProofCreateDto: InternalProofCreateDto) -> Single<Moya.Response>
    func postProofExternal(externalProofCreateDto: ExternalProofCreateDto) -> Single<Moya.Response>
    func postProofSpecial(specialProofCreateDto: SpecialProofCreateDto) -> Single<Moya.Response>
    func getProofs() -> Single<Result<ProofDtoPagedResultDto, ErrorResponse>>
    func deleteProof(id: String) -> Single<Moya.Response>
    func getProofDetail(id: String) -> Single<Result<ProofDetailDto, ErrorResponse>>
    func updateProofInternal(proofId: String, internalProofCreateDto: InternalProofCreateDto) -> Single<Moya.Response>
    func updateProofExternal(proofId: String, externalProofCreateDto: ExternalProofCreateDto) -> Single<Moya.Response>
    func updateProofSpecial(proofId: String, specialProofCreateDto: SpecialProofCreateDto) -> Single<Moya.Response>
}
