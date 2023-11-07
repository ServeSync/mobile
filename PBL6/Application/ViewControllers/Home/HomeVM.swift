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
    
    func fetchDataRemote() -> Observable<HandleStatus> {
        let happeningObservable = remoteRepository.getEventsByStatus(status: .Happening, page: 0)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
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
        
        let upcomingObservable = remoteRepository.getEventsByStatus(status: .Upcoming, page: 0)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
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
        
        let doneObservable = remoteRepository.getEventsByStatus(status: .Done, page: 0)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
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
    
    func fetchDataLocal() {
        return localRespository.getEvents()
            .subscribe(onNext: {[weak self] data in
                guard let self = self else { return }
                self.favoriteEvents = data
                self.favoriteEventsR.accept(self.favoriteEvents)
            })
            .disposed(by: bag)
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
