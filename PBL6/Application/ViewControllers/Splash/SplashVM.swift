//
//  SplashVM.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import Foundation
import RxSwift

class SplashVM: BaseVM {
    func refreshToken() -> Observable<HandleStatus>{
        let accessToken = UserDefaultHelper.shared.accessToken
        let refreshToken = UserDefaultHelper.shared.refreshToken
        let authCredentialDto = AuthCredentialDto(accessToken: accessToken!, refreshToken: refreshToken!)
        return remoteRepository.resfreshToken(authCredentialDto: authCredentialDto)
            .asObservable()
            .flatMap{ result -> Observable<HandleStatus> in
                switch result {
                case .success(let data):
                    UserDefaultHelper.shared.accessToken = data.accessToken
                    UserDefaultHelper.shared.refreshToken = data.refreshToken
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
            .subscribe(on: MainScheduler.instance)
    }
}

