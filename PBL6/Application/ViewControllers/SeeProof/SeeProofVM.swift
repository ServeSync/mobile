//
//  SeeProofVM.swift
//  PBL6
//
//  Created by KietKoy on 09/12/2023.
//

import Foundation
import RxSwift

class SeeProofVM: BaseVM {
    var idProof: String = ""
    private var proofDetail: ProofDetailDto = ProofDetailDto()
    let proofDetailData = PublishData<ProofDetailDto>()
    
    func fetchData() -> Observable<HandleStatus> {
        return remoteRepository.getProofDetail(id: idProof)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] result -> Observable<HandleStatus> in
                guard let self = self else {  return .just(.Error(error: nil)) }
                switch result {
                case .success(let data):
                    proofDetail = data
                    proofDetailData.accept(proofDetail)
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
}
