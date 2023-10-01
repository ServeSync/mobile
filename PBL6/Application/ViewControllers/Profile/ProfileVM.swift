//
//  ProfileVM.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import Foundation

class ProfileVM: BaseVM {
    
    let profileDetailData = PublishData<StudentDetailDto>()
    
    func fetchData() {
        loadingData.accept(true)
        remoteRepository.getProfileDetail()
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .subscribe(onNext: { [weak self] responseData in
                guard let self = self else { return }
                loadingData.accept(false)
                switch responseData {
                case .success(let data):
                    profileDetailData.accept(data)
                case .failure(let error):
                    messageData.accept(AlertMessage(type: .error, description: error.localizedDescription))
                }
            })
            .disposed(by: bag)
    }
}
