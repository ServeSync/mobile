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
    
    private var speakersData = [BasicRepresentativeInEventDto]()
    let speakersDataS = PublishData<[BasicRepresentativeInEventDto]>()
    
    private var organizationsData = [OrganizationInEventDto]()
    let organizationsDataS = PublishData<[OrganizationInEventDto]>()
    
    let eventDetailItemR = PublishRelay<EventDetailDto>()
    var eventId: String = ""
    
    private var buttonActionStatus: ButtonActionStatus = .none
    
    func fetchData() -> Observable<HandleStatus> {
        return remoteRepository.getEventById(id: eventId)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] result -> Observable<HandleStatus> in
                guard let self = self else {  return .just(.Error(error: nil)) }
                switch result {
                case .success(let data):
                    eventDetailItem = data
                    updateEventDetailsWithLocalData()
                    eventDetailItemR.accept(data)
                    rolesDataS.accept(data.roles)
                    for organization in eventDetailItem.organizations {
                        speakersData.append(contentsOf: organization.representatives)
                    }
                    speakersDataS.accept(speakersData)
                    organizationsDataS.accept(data.organizations)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
    func updateButtonActionStatus(status: ButtonActionStatus) {
        self.buttonActionStatus = status
    }
    
    func getButtonActionStatus() -> ButtonActionStatus {
        return self.buttonActionStatus
    }
    
    func updateRoleRegister(roleId: String) {
        if let roleIndex = eventDetailItem.roles.firstIndex(where: { $0.id == roleId }) {
            eventDetailItem.roles[roleIndex].isRegistered = true
        }
    }
}

extension EventDetailVM {
    private func updateEventDetailsWithLocalData() {
        localRespository.findEventById(withId: eventDetailItem.id)
            .subscribe(onNext: {[weak self] localEventItem in
                guard let self = self else { return }
                if let localModItem = localEventItem {
                    self.eventDetailItem.isFavorite = true
                } else {
                    self.eventDetailItem.isFavorite = false
                }
                self.eventDetailItemR.accept(self.eventDetailItem)
            })
            .disposed(by: bag)
    }
    
    func favoriteEventChanged() {
        eventDetailItem.isFavorite.toggle()
        
        if eventDetailItem.isFavorite {
            localRespository.addSite(event: eventDetailItem.asFlatEventDto())
                .subscribe(onNext: {[weak self] _ in
                    guard let self = self else { return }
                    self.eventDetailItemR.accept(eventDetailItem)
                })
                .disposed(by: bag)
        } else {
            localRespository.deleteEvent(withId: eventDetailItem.id)
                .subscribe(onNext: {[weak self] _ in
                    guard let self = self else { return }
                    self.eventDetailItemR.accept(eventDetailItem)
                })
                .disposed(by: bag)
        }
    }
}
