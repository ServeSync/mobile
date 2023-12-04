//
//  CreateProofVM.swift
//  PBL6
//
//  Created by KietKoy on 30/11/2023.
//

import Foundation
import RxSwift

class CreateProofVM: BaseVM {
    let typeEvent: [String] = [
        "internal_event".localized,
        "external_event".localized
    ]
    
    private var registeredStudentInEvent: [StudentRegisteredEventDto] = []
    let registeredStudentInEventData = PublishData<[StudentRegisteredEventDto]>()
    
    func getRegisteredStudentInEvent() -> Observable<HandleStatus> {
        return remoteRepository.getEventRegistered(studentId: UserDefaultHelper.shared.studentId!)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status in
                switch status {
                case .success(let response):
                    self.registeredStudentInEvent = response.data
                    self.registeredStudentInEventData.accept(self.registeredStudentInEvent)
                    return .Success
                case .failure(let error):
                    return .Error(error: error)
                }
            }
    }
}

extension CreateProofVM {
    func getEvent(by position: Int) -> StudentRegisteredEventDto {
        return self.registeredStudentInEvent[position]
    }
}
