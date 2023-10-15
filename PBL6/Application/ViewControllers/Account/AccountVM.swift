//
//  AccountVM.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import Foundation
import RxSwift

class AccountVM: BaseVM {
    let profileDetailData = PublishData<StudentDetailDto>()
    
    func fetchData() -> Observable<HandleStatus>{
        
        return remoteRepository.getProfileDetail()
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil))}
                switch result {
                case .success(let data):
                    profileDetailData.accept(data)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
}
