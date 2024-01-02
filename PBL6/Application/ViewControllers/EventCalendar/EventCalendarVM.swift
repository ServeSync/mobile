//
//  EventCalendarVM.swift
//  PBL6
//
//  Created by KietKoy on 26/12/2023.
//

import Foundation
import RxSwift

class EventCalendarVM: BaseVM {
    var dailyEvents: [FlatEventDto] = []
    var events: [FlatEventDto] = []
    var datesHavingEvents: [Date] = []
    let eventsData = PublishData<[FlatEventDto]>()
    
    func fetchData() -> Observable<HandleStatus> {
        return remoteRepository.getAllYourEvents()
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status in
                switch status {
                case .success(let response):
                    self.events = response.data
                    self.eventsData.accept(self.events)
                    self.fetchDatesHavingEvents()
                    return .Success
                case .failure(let error):
                    return .Error(error: error)
                }
            }
    }
    
    func fetchDatesHavingEvents() {
        self.events.forEach{ event in
            if let date = convertStringToDate(event.startAt) {
                self.datesHavingEvents.append(date)
            }
        }
    }
    
    func fetchDailysEvents(date: Date) {
        self.dailyEvents.removeAll()
        self.events.forEach{ event in
            if let d = convertStringToDate(event.startAt){
                if compareDatesIgnoringTime(date1: d, date2: date) {
                    self.dailyEvents.append(event)
                }
            }
        }
    }
}
