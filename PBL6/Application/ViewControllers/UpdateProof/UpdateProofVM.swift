//
//  UpdateProofVM.swift
//  PBL6
//
//  Created by KietKoy on 25/12/2023.
//

import Foundation
import RxSwift

class UpdateProofVM: BaseVM {
    var proofId: String?
    let proofItemData = PublishData<ProofDetailDto>()
    var proofItem: ProofDetailDto?
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
    
    func fetchData() -> Observable<HandleStatus> {
        return remoteRepository.getProofDetail(id: proofId!)
            .trackError(self.errorTracker)
            .trackActivity(self.indicatorLoading)
            .flatMap{[weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil)) }
                switch result {
                case .success(let response):
                    proofItem = response
                    proofItemData.accept(response)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
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
    
    func handleUpdateInternalProof(description: String) -> Observable<HandleStatus> {
        return remoteRepository.postImage(image: self.proofImage!)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil))}
                switch result {
                case .success(let data):
                    if self.studentRegisteredEventDto == nil {
                        self.studentRegisteredEventDto = getEvent(by: self.proofItem!.eventId)
                    }
                    let internalProofCreateDto = InternalProofCreateDto(eventId: self.studentRegisteredEventDto!.id,
                                                                     eventRoleId: self.studentRegisteredEventDto!.roleId,
                                                                     description: description,
                                                                     imageUrl: data.url,
                                                                        attendanceAt: FormatUtils.formatDateToString(self.attendanceTime!, formatterString: "yyyy-MM-dd'T'HH:mm"))
                    return remoteRepository.updateInternalProof(proofId: self.proofId!, internalProofCreateDto: internalProofCreateDto)
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
    
    func handleUpdateExternalProof(eventName: String,
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
                    if eventActivity == nil {
                        self.eventActivity = getEventActivities(by: self.proofItem!.activity.id)
                    }
                    let externalProofCreateDto = ExternalProofCreateDto(eventName: eventName,
                                                                        address: address,
                                                                        organizationName: organizationName,
                                                                        role: role,
                                                                        score: score,
                                                                        attendanceAt: FormatUtils.formatDateToString(self.attendanceTime!, formatterString: "yyyy-MM-dd'T'HH:mm"),
                                                                        startAt: FormatUtils.formatDateToString(self.startTime!, formatterString: "yyyy-MM-dd'T'HH:mm"),
                                                                        endAt: FormatUtils.formatDateToString(self.endTime!, formatterString: "yyyy-MM-dd'T'HH:mm"),
                                                                        activityId: self.eventActivity!.id,
                                                                        description: description,
                                                                        imageUrl: data.url)
                    return remoteRepository.updateExternalProod(proofId: self.proofId!, externalProofCreateDto: externalProofCreateDto)
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
    
    func handleUpdateSpecialProof(title: String,
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
                    return remoteRepository.updateSpecialProof(proofId: self.proofId!, specialProofCreateDto: specialProofCreateDto)
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

extension UpdateProofVM {
    func getEvent(by position: Int) -> StudentRegisteredEventDto {
        self.studentRegisteredEventDto = self.registeredStudentInEvents[position]
        return self.registeredStudentInEvents[position]
    }
    
    func getEvent(by id: String) -> StudentRegisteredEventDto {
        self.studentRegisteredEventDto = self.registeredStudentInEvents.filter { $0.id == id}.first
        return self.registeredStudentInEvents.filter { $0.id == id}.first ?? StudentRegisteredEventDto()
    }
    
    func isContaintEvent(with name: String) -> Bool {
        return self.registeredStudentInEvents.contains(where: {$0.name == name})
    }
    
    func getEventActivities(by id: String) -> EventActivityDto {
        self.eventActivity = self.eventActivities.filter { $0.id == id}.first
        return self.eventActivity ?? EventActivityDto()
    }
    
    func getEventActivities(by position: Int) -> EventActivityDto {
        self.eventActivity = self.eventActivities[position]
        return self.eventActivities[position]
    }
}
