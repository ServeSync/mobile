//
//  SeeProofDetailVM.swift
//  PBL6
//
//  Created by KietKoy on 02/01/2024.
//

import Foundation
import RxSwift

class SeeProofDetailVM: BaseVM {
    var proofId: String?
    let proofItemData = PublishData<ProofDetailDto>()
    
    func fetchData() -> Observable<HandleStatus> {
        return remoteRepository.getProofDetail(id: proofId!)
            .trackError(self.errorTracker)
            .trackActivity(self.indicatorLoading)
            .flatMap{[weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil)) }
                switch result {
                case .success(let response):
                    proofItemData.accept(response)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
}
