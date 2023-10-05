//
//  SplashVM.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import Foundation
import RxSwift

class SplashVM: BaseVM {
    func refreshToken(completion: @escaping (HandleStatus) -> Void) {
        let accessToken = UserDefaultHelper.shared.accessToken
        let refreshToken = UserDefaultHelper.shared.refreshToken
        let authCredentialDto = AuthCredentialDto(accessToken: accessToken!, refreshToken: refreshToken!)
        remoteRepository.resfreshToken(authCredentialDto: authCredentialDto)
            .asObservable()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    UserDefaultHelper.shared.accessToken = data.accessToken
                    UserDefaultHelper.shared.refreshToken = data.refreshToken
                    completion(.Success)
                case .failure(_):
                    completion(.Error(error: nil))
                }
            })
            .disposed(by: bag)
    }
}

