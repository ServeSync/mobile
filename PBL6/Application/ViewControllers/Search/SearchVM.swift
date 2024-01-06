//
//  SearchVM.swift
//  PBL6
//
//  Created by KietKoy on 05/11/2023.
//

import Foundation
import RxSwift
import RxRelay

class SearchVM: BaseVM {
    var eventsData = PublishData<[FlatEventDto]>()
    private var events = [FlatEventDto]()
    var currentPage: Int = 1
    var totalPage: Int = 0
    var keyword: String = ""
    
    func searchEvent(keyword: String) -> Observable<HandleStatus> {
        self.keyword = keyword
        events.removeAll()
        return remoteRepository.searchEvent(keyword: keyword, page: 0)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap { [weak self] status -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil))  }
                switch status {
                case .success(let response):
                    self.totalPage = response.totalPages
                    events = response.data
                    eventsData.accept(events)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
    func loadMore() -> Observable<HandleStatus> {
        self.currentPage += 1
        if self.currentPage > self.totalPage {
            return .just(.Success)
        }
        
        return remoteRepository.searchEvent(keyword: self.keyword, page: self.currentPage)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap { [weak self] status -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil)) }
                switch status {
                case .success(let response):
                    events.append(contentsOf: response.data)
                    eventsData.accept(events)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
    func refreshData() -> Observable<HandleStatus> {
        return searchEvent(keyword: self.keyword)
    }
}

