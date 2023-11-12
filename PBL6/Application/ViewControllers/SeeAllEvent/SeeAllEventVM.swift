//
//  SeeAllEventVM.swift
//  PBL6
//
//  Created by KietKoy on 17/10/2023.
//

import Foundation
import RxRelay
import RxSwift


class SeeAllEventVM: BaseVM {
    var eventStatus: EventStatus?
    
    var eventsR = PublishRelay<[FlatEventDto]>()
    private var events = [FlatEventDto]()
    var currentPage: Int = 1
    var totalPage: Int = 0
    
    func fetchData(isRefresh: Bool, page: Int) -> Observable<HandleStatus> {
        switch self.eventStatus {
        case .Favorite:
            return localRespository.getEvents()
                .trackError(errorTracker)
                .trackActivity(indicatorLoading)
                .flatMap{[weak self] data -> Observable<HandleStatus> in
                    guard let self = self else { return .just(.Error(error: nil))}
                    events = data
                    eventsR.accept(events)
                    return .just(.Success)
                }
        default:
            return remoteRepository.getEventsByStatus(status: self.eventStatus!, page: page)
                .trackError(errorTracker)
                .trackActivity(indicatorLoading)
                .flatMap { [weak self] status -> Observable<HandleStatus> in
                    guard let self = self else { return .just(.Error(error: nil)) }
                    switch status {
                    case .success(let response):
                        self.totalPage = response.totalPages
                        if isRefresh {
                            events.removeAll()
                        }
                        events = response.data
                        eventsR.accept(events)
                        return .just(.Success)
                    case .failure(let error):
                        return .just(.Error(error: error))
                    }
                }
        }
    }
    
    func loadMore() -> Observable<HandleStatus> {
        self.currentPage += 1
        if self.currentPage > self.totalPage {
            return .just(.Success)
        }
         
        return remoteRepository.getEventsByStatus(status: self.eventStatus!, page: self.currentPage)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] status -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil)) }
                switch status {
                case .success(let response):
                    events.append(contentsOf: response.data)
                    eventsR.accept(events)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
}
