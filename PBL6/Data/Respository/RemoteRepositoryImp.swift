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
    
    func changePassword(changePassworDto: ChangePassworDto) -> Single<Moya.Response> {
        return apiService.changePassword(changePassworDto: changePassworDto)
    }
    
    //MARK: - Student
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
    
    func getEducationProgam() -> Single<Result<StudentEducationProgramDto, ErrorResponse>> {
        return apiService.getEducationProgam()
    }
    
    func getAttendanceEvents() -> Single<Result<StudentAttendanceEventDtoPagedResultDto, ErrorResponse>> {
        return apiService.getAttendanceEvents()
    }
    
    func exportFile(exportStudentAttendanceEventsDto: ExportStudentAttendanceEventsDto) -> Single<Moya.Response> {
        return apiService.exportFile(exportStudentAttendanceEventsDto: exportStudentAttendanceEventsDto)
    }
    
    //MARK: - Event
    
    func getEventsByStatus(status: EventStatus, page: Int = 0) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>> {
        return apiService.getEventsByStatus(status: status, page: page)
    }
    
    func getEventForSelf(status: EventStatus) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>> {
        return apiService.getEventForSelf(status: status)
    }
    
    func searchEvent(keyword: String, page: Int) -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>> {
        return apiService.searchEvent(keyword: keyword, page: page)
    }
    
    func getEventById(id: String) -> RxSwift.Single<Result<EventDetailDto, ErrorResponse>> {
        return apiService.getEventById(id: id)
    }
    
    func registerEvent(eventRegisterDto: EventRegisterDto) -> Single<Moya.Response> {
        return apiService.registerEvent(eventRegisterDto: eventRegisterDto)
    }
    
    func rollcallEvent(studentAttendEventDto: StudentAttendEventDto, eventId: String) -> Single<Moya.Response> {
        return apiService.rollcallEvent(studentAttendEventDto: studentAttendEventDto, eventId: eventId)
    }
    
    func getEventRegistered(studentId: String) -> Single<Result<StudentRegisteredEventDtoPagedResultDto, ErrorResponse>> {
        return apiService.getEventRegistered(studentId: studentId)
    }
    
    func getEventActivities(type: EventActivityType) -> Single<Result<[EventActivityDto], ErrorResponse>> {
        return apiService.getEventActivities(type: type)
    }
    
    func getAllYourEvents() -> Single<Result<FlatEventDtoPagedResultDto, ErrorResponse>> {
        return apiService.getAllYourEvents()
    }
    
    //MARK: - Proof
    func postProofInternal(internalProofCreateDto: InternalProofCreateDto) -> Single<Moya.Response> {
        return apiService.postProofInternal(internalProofCreateDto: internalProofCreateDto)
    }
    
    func postProofExternal(externalProofCreateDto: ExternalProofCreateDto) -> Single<Moya.Response> {
        return apiService.postProofExternal(externalProofCreateDto: externalProofCreateDto)
    }
    
    func postProofSpecial(specialProofCreateDto: SpecialProofCreateDto) -> Single<Moya.Response> {
        return apiService.postProofSpecial(specialProofCreateDto: specialProofCreateDto)
    }
    
    func getProofs() -> Single<Result<ProofDtoPagedResultDto, ErrorResponse>> {
        return apiService.getProofs()
    }
    
    func deleteProof(id: String) -> Single<Moya.Response> {
        return apiService.deleteProof(id: id)
    }
    
    func getProofDetail(id: String) -> Single<Result<ProofDetailDto, ErrorResponse>> {
        return apiService.getProofDetail(id: id)
    }
    
    func updateInternalProof(proofId: String, internalProofCreateDto: InternalProofCreateDto) -> Single<Moya.Response> {
        return apiService.updateProofInternal(proofId: proofId, internalProofCreateDto: internalProofCreateDto)
    }
    
    func updateExternalProod(proofId: String, externalProofCreateDto: ExternalProofCreateDto) -> Single<Moya.Response> {
        return apiService.updateProofExternal(proofId: proofId, externalProofCreateDto: externalProofCreateDto)
    }
    
    func updateSpecialProof(proofId: String, specialProofCreateDto: SpecialProofCreateDto) -> Single<Moya.Response> {
        return apiService.updateProofSpecial(proofId: proofId, specialProofCreateDto: specialProofCreateDto)
    }
}
