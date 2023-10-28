//
//  HomeVM.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Foundation
import RxSwift
import RxRelay

class HomeVM: BaseVM {
    var hapeningEvents: [FlatEventDto] = []
    var upcomingEvents: [FlatEventDto] = []
    var doneEvents: [FlatEventDto] = []
    var favoriteEvents: [FlatEventDto] = []
    
    let happeningEventsR = PublishRelay<[FlatEventDto]>()
    let upcomingEventsR = PublishRelay<[FlatEventDto]>()
    let doneEventsR = PublishRelay<[FlatEventDto]>()
    let favoriteEventsR = PublishRelay<[FlatEventDto]>()
    
    func fetchData() -> Observable<HandleStatus> {
        let happeningObservable = remoteRepository.getEventsByStatus(status: .Happening, page: 0)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status in
                switch status {
                case .success(let data):
                    self.hapeningEvents = data.data
                    print("hapeningEvents \(self.hapeningEvents.count) @@@")
                    self.happeningEventsR.accept(data.data)
                    return HandleStatus.Success
                case .failure(let error):
                    return HandleStatus.Error(error: error)
                }
            }
        
        let upcomingObservable = remoteRepository.getEventsByStatus(status: .Upcoming, page: 0)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status in
                switch status {
                case .success(let data):
                    self.upcomingEvents = data.data
                    print("upcomingEvents \(self.upcomingEvents.count) @@@")
                    self.upcomingEventsR.accept(data.data)
                    return HandleStatus.Success
                case .failure(let error):
                    return HandleStatus.Error(error: error)
                }
            }
        
        let doneObservable = remoteRepository.getEventsByStatus(status: .Done, page: 0)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status in
                switch status {
                case .success(let data):
                    self.doneEvents = data.data
                    print("doneEvents \(self.doneEvents.count) @@@")
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
