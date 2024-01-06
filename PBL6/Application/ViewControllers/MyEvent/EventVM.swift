//
//  EventVM.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import Foundation
import RxRelay
import RxSwift

class EventVM: BaseVM {
    var hapeningEvents: [FlatEventDto] = []
    var upcomingEvents: [FlatEventDto] = []
    var doneEvents: [FlatEventDto] = []
    
    let happeningEventsR = PublishRelay<[FlatEventDto]>()
    let upcomingEventsR = PublishRelay<[FlatEventDto]>()
    let doneEventsR = PublishRelay<[FlatEventDto]>()
    
    func fetchDataRemote() -> Observable<HandleStatus> {
        let happeningObservable = remoteRepository.getEventForSelf(status: .Happening)
            .trackError(self.errorTracker)
            .trackActivity(self.indicatorLoading)
            .map { status in
                switch status {
                case .success(let data):
                    self.hapeningEvents = data.data
                    self.happeningEventsR.accept(data.data)
                    return HandleStatus.Success
                case .failure(let error):
                    return HandleStatus.Error(error: error)
                }
            }
        
        let upcomingObservable = remoteRepository.getEventForSelf(status: .Upcoming)
            .trackError(self.errorTracker)
            .trackActivity(self.indicatorLoading)
            .map { status in
                switch status {
                case .success(let data):
                    self.upcomingEvents = data.data
                    self.upcomingEventsR.accept(data.data)
                    return HandleStatus.Success
                case .failure(let error):
                    return HandleStatus.Error(error: error)
                }
            }
        
        let doneObservable = remoteRepository.getEventForSelf(status: .Done)
            .trackError(self.errorTracker)
            .trackActivity(self.indicatorLoading)
            .map { status in
                switch status {
                case .success(let data):
                    self.doneEvents = data.data
                    self.doneEventsR.accept(data.data)
                    return HandleStatus.Success
                case .failure(let error):
                    return HandleStatus.Error(error: error)
                }
            }
        
        return Observable.merge(happeningObservable, upcomingObservable, doneObservable)
            .observe(on: MainScheduler.instance)
    }

    func searchEvent(textSearch: String) {
        if textSearch.isEmpty {
            doneEventsR.accept(self.doneEvents)
            happeningEventsR.accept(self.hapeningEvents)
            upcomingEventsR.accept(self.upcomingEvents)
        } else {
            doneEventsR.accept(self.doneEvents.filter({$0.name.lowercased().contains(textSearch.lowercased())}))
            happeningEventsR.accept(self.hapeningEvents.filter({$0.name.lowercased().contains(textSearch.lowercased())}))
            upcomingEventsR.accept(self.upcomingEvents.filter({$0.name.lowercased().contains(textSearch.lowercased())}))
        }
    }
}
