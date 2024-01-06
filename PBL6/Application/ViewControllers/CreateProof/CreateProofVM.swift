//
//  CreateProofVM.swift
//  PBL6
//
//  Created by KietKoy on 30/11/2023.
//

import UIKit
import RxSwift

class CreateProofVM: BaseVM {
    let typeEvent: [String] = [
        "internal_proof".localized,
        "external_proof".localized,
        "special_proof".localized
    ]
    
    var attendanceTime: Date?
    var startTime: Date?
    var endTime: Date?
    var proofImage: UIImage?
    
    private var registeredStudentInEvents: [StudentRegisteredEventDto] = []
    let registeredStudentInEventData = PublishData<[StudentRegisteredEventDto]>()
    private var studentRegisteredEventDto: StudentRegisteredEventDto?
    
    private var eventActivities: [EventActivityDto] = []
    let eventActivitiestData = PublishData<[EventActivityDto]>()
    var eventActivity: EventActivityDto?
    
    func getRegisteredStudentInEvent() -> Observable<HandleStatus> {
        return remoteRepository.getEventRegistered(studentId: UserDefaultHelper.shared.studentId!)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status in
                switch status {
                case .success(let response):
                    self.registeredStudentInEvents = response.data
                    self.registeredStudentInEventData.accept(self.registeredStudentInEvents)
                    return .Success
                case .failure(let error):
                    return .Error(error: error)
                }
            }
    }
    
    func getEventActivities(type: EventActivityType) -> Observable<HandleStatus> {
        return remoteRepository.getEventActivities(type: type)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status in
                switch status {
                case .success(let data):
                    self.eventActivities = data
                    self.eventActivitiestData.accept(self.eventActivities)
                    return .Success
                case .failure(let error):
                    return .Error(error: error)
                }
            }
    }
    
    func handleCreateInternalProof(description: String) -> Observable<HandleStatus> {
        return remoteRepository.postImage(image: self.proofImage!)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil))}
                switch result {
                case .success(let data):
                    let internalProofCreateDto = InternalProofCreateDto(eventId: self.studentRegisteredEventDto!.id,
                                                                     eventRoleId: self.studentRegisteredEventDto!.roleId,
                                                                     description: description,
                                                                     imageUrl: data.url,
                                                                        attendanceAt: FormatUtils.formatDateToString(self.attendanceTime!, formatterString: "yyyy-MM-dd'T'HH:mm"))
                    return remoteRepository.postProofInternal(internalProofCreateDto: internalProofCreateDto)
                        .trackError(errorTracker)
                        .trackActivity(indicatorLoading)
                        .map { response in
                            if 200...299 ~= response.statusCode {
                                return .Success
                            } else {
                                let errorCode = try response.mapString(atKeyPath: "code")
                                let message = try response.mapString(atKeyPath: "message")
                                return .Error(error: ErrorResponse(code: errorCode, message: message))
                            }
                        }
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
    func handleCreateExternalProof(eventName: String,
                                   address: String,
                                   organizationName: String,
                                   role: String,
                                   score: Double,
                                   description: String) -> Observable<HandleStatus> {
        return remoteRepository.postImage(image: self.proofImage!)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil))}
                switch result {
                case .success(let data):
                    let externalProofCreateDto = ExternalProofCreateDto(eventName: eventName,
                                                                        address: address,
                                                                        organizationName: organizationName,
                                                                        role: role,
                                                                        score: score,
                                                                        attendanceAt: FormatUtils.formatDateToString(self.attendanceTime!, formatterString: "yyyy-MM-dd'T'HH:mm"),
                                                                        startAt: FormatUtils.formatDateToString(self.startTime!, formatterString: "yyyy-MM-dd'T'HH:mm"),
                                                                        endAt: FormatUtils.formatDateToString(self.endTime!, formatterString: "yyyy-MM-dd'T'HH:mm"),
                                                                        activityId: eventActivity!.id,
                                                                        description: description,
                                                                        imageUrl: data.url)
                    return remoteRepository.postProofExternal(externalProofCreateDto: externalProofCreateDto)
                        .trackError(errorTracker)
                        .trackActivity(indicatorLoading)
                        .map { response in
                            if 200...299 ~= response.statusCode {
                                return .Success
                            } else {
                                let errorCode = try response.mapString(atKeyPath: "code")
                                let message = try response.mapString(atKeyPath: "message")
                                return .Error(error: ErrorResponse(code: errorCode, message: message))
                            }
                        }
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
    func handleCreateSpecialProof(title: String,
                                   role: String,
                                   score: Double,
                                   description: String) -> Observable<HandleStatus> {
        return remoteRepository.postImage(image: self.proofImage!)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil))}
                switch result {
                case .success(let data):
                    let specialProofCreateDto = SpecialProofCreateDto(title: title,
                                                                      role: role,
                                                                      score: score,
                                                                      startAt: FormatUtils.formatDateToString(self.startTime!, formatterString: "yyyy-MM-dd'T'HH:mm"),
                                                                      endAt: FormatUtils.formatDateToString(self.endTime!, formatterString: "yyyy-MM-dd'T'HH:mm"),
                                                                      activityId: eventActivity!.id,
                                                                      description: description,
                                                                      imageUrl: data.url)
                    return remoteRepository.postProofSpecial(specialProofCreateDto: specialProofCreateDto)
                        .trackError(errorTracker)
                        .trackActivity(indicatorLoading)
                        .map { response in
                            if 200...299 ~= response.statusCode {
                                return .Success
                            } else {
                                let errorCode = try response.mapString(atKeyPath: "code")
                                let message = try response.mapString(atKeyPath: "message")
                                return .Error(error: ErrorResponse(code: errorCode, message: message))
                            }
                        }
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
}

extension CreateProofVM {
    func getEvent(by position: Int) -> StudentRegisteredEventDto {
        self.studentRegisteredEventDto = self.registeredStudentInEvents[position]
        return self.registeredStudentInEvents[position]
    }
    
    func isContaintEvent(with name: String) -> Bool {
        return self.registeredStudentInEvents.contains(where: {$0.name == name})
    }
    
    func getEventActivities(by position: Int) -> EventActivityDto {
        self.eventActivity = self.eventActivities[position]
        return self.eventActivities[position]
    }
}
