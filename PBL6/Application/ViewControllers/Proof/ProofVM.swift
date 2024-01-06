//
//  ProofVM.swift
//  PBL6
//
//  Created by KietKoy on 29/11/2023.
//

import Foundation
import RxSwift


class ProofVM: BaseVM {
    private var proofItems: [ProofDto] = []
    let proofItemsData = PublishData<[ProofDto]>()
    
    func fetchData() -> Observable<HandleStatus> {
        return remoteRepository.getProofs()
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{[weak self] result -> Observable<HandleStatus> in
                guard let self = self else {  return .just(.Error(error: nil)) }
                
                switch result {
                case .success(let response):
                    proofItems = response.data
                    proofItemsData.accept(proofItems)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
    func handleDeleteProof(_ proofItem: ProofDto) -> Observable<HandleStatus>{
        self.proofItems.removeAll(where: {$0.id == proofItem.id})
        self.proofItemsData.accept(proofItems)
        return remoteRepository.deleteProof(id: proofItem.id)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { response in
                if 200...299 ~= response.statusCode {
                    return .Success
                } else {
                    let errorCode = try response.mapString(atKeyPath: "code")
                    let message = try response.mapString(atKeyPath: "message")
                    return .Error(error: ErrorResponse(code: errorCode, message: message))
                }
            }
    }
}
