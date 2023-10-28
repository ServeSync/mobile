//
//  EventDetailVM.swift
//  PBL6
//
//  Created by KietKoy on 13/10/2023.
//

import Foundation
import RxSwift
import RxRelay

class EventDetailVM: BaseVM {
    var eventDetailItem: EventDetailDto = EventDetailDto()
    private var rolesData = [EventRoleDto]()
    let rolesDataS = PublishData<[EventRoleDto]>()
    let eventDetailItemR = PublishRelay<EventDetailDto>()
    var eventId: String = ""
    
    func fetchData() -> Observable<HandleStatus> {
        return remoteRepository.getEventById(id: eventId)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] result -> Observable<HandleStatus> in
                guard let self = self else {  return .just(.Error(error: nil)) }
                switch result {
                case .success(let data):
                    eventDetailItem = data
                    eventDetailItemR.accept(data)
                    rolesDataS.accept(data.roles)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
}
