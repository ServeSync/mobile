//
//  ProfileVM.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import Foundation
import RxSwift

class ProfileVM: BaseVM {
    
    let profileDetailData = PublishData<StudentDetailDto>()
    var profileDetail: StudentDetailDto?
    
    func fetchData() -> Observable<HandleStatus>{
//        loadingData.accept(true)
//        remoteRepository.getProfileDetail()
//            .trackError(errorTracker)
//            .trackActivity(indicatorLoading)
//            .subscribe(onNext: { [weak self] responseData in
//                guard let self = self else { return }
//                loadingData.accept(false)
//                switch responseData {
//                case .success(let data):
//                    profileDetailData.accept(data)
//                    profileDetail = data
//                case .failure(let error):
//                    messageData.accept(AlertMessage(type: .error, description: error.localizedDescription))
//                }
//            })
//            .disposed(by: bag)
        
        return remoteRepository.getProfileDetail()
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil))}
                switch result {
                case .success(let data):
                    profileDetailData.accept(data)
                    profileDetail = data
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
}
