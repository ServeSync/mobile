//
//  HomeVM.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Foundation
import RxSwift

class HomeVM: BaseVM {
    var hapeningEvents: [FlatEventDto] = []
    var upcomingEvents: [FlatEventDto] = []
    var doneEvents: [FlatEventDto] = []
    var favoriteEvents: [FlatEventDto] = []
    
//    func fetchData() -> Observable<HandleStatus>{
//        func fetchData() -> Observable<HandleStatus> {
//            let happeningObservable = remoteRepository.getEventsByStatus(status: .Happening, page: 0)
//                .trackError(errorTracker)
//                .trackActivity(indicatorLoading)
//            
//            let upcomingObservable = remoteRepository.getEventsByStatus(status: .Upcoming, page: 0)
//                .trackError(errorTracker)
//                .trackActivity(indicatorLoading)
//            
//            let doneObservable = remoteRepository.getEventsByStatus(status: .Done, page: 0)
//                .trackError(errorTracker)
//                .trackActivity(indicatorLoading)
//            
//            return Observable
//                .merge([happeningObservable, upcomingObservable, doneObservable])
//                .subscribe(onNext: { [weak self] status in
//                    guard let self = self else { return }
//                    
//                    switch status {
//                    case .success(let data):
//                        switch data.status {
//                        case .Happening:
//                            self.hapeningEvents = data.data
//                            print("hapeningEvents \(self.hapeningEvents.count) @@@")
//                        case .Upcoming:
//                            self.upcomingEvents = data.data
//                            print("upcomingEvents \(self.upcomingEvents.count) @@@")
//                        case .Done:
//                            self.doneEvents = data.data
//                            print("doneEvents \(self.doneEvents.count) @@@")
//                        }
//                    case .failure(_):
//                        print("123")
//                    }
//                })
//                .disposed(by: bag)
//        }
    
    func fetchData() -> Observable<HandleStatus> {
        let happeningObservable = remoteRepository.getEventsByStatus(status: .Happening, page: 0)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status in
                switch status {
                case .success(let data):
                    self.hapeningEvents = data.data
                    print("hapeningEvents \(self.hapeningEvents.count) @@@")
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
                    return HandleStatus.Success
                case .failure(let error):
                    return HandleStatus.Error(error: error)
                }
            }
        
        return Observable.merge(happeningObservable, upcomingObservable, doneObservable)
            .observe(on: MainScheduler.instance)
    }

}
