//
//  AnalysisVM.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import Foundation
import RxSwift

class AnalysisVM: BaseVM {
    let educationProgramData = PublishData<StudentEducationProgramDto>()
    let attendanceEventsData = PublishData<[StudentAttendanceEventDto]>()
    private var attendanceEvents = [StudentAttendanceEventDto]()
    let studentNameData = PublishData<String>()
    
    var currentPage: Int = 1
    var totalPage: Int = 0
    
    func fetchData(isRefresh: Bool) -> Observable<HandleStatus>{
        let educationProgramObservable = remoteRepository.getEducationProgam()
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status in
                switch status {
                case .success(let data):
                    self.educationProgramData.accept(data)
                    return HandleStatus.Success
                case .failure(let error):
                    return HandleStatus.Error(error: error)
                }
            }
            
        let attendanceEventsObservable = remoteRepository.getAttendanceEvents(page: 0)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status  in
                switch status {
                case .success(let response):
                    self.totalPage = response.totalPages
                    if isRefresh {
                        self.attendanceEvents.removeAll()
                    }
                    self.attendanceEvents = response.data
                    self.attendanceEventsData.accept(self.attendanceEvents)
                    return HandleStatus.Success
                case .failure(let error):
                    return HandleStatus.Error(error: error)
                }
            }
        
        let profileObservable = remoteRepository.getProfileDetail()
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { status  in
                switch status {
                case .success(let data):
                    self.studentNameData.accept(data.fullName)
                    return HandleStatus.Success
                case .failure(let error):
                    return HandleStatus.Error(error: error)
                }
            }
        
        return Observable.merge(educationProgramObservable, attendanceEventsObservable, profileObservable)
            .observe(on: MainScheduler.instance)
    }
    
    func loadMore() -> Observable<HandleStatus> {
        self.currentPage += 1
        if self.currentPage > self.totalPage {
            return .just(.Success)
        }
         
        return remoteRepository.getAttendanceEvents(page: self.currentPage)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] status -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil)) }
                switch status {
                case .success(let response):
                    attendanceEvents.append(contentsOf: response.data)
                    attendanceEventsData.accept(attendanceEvents)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
}
