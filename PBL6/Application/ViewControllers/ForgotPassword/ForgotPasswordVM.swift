//
//  ForgotPasswordVM.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import Foundation
import RxSwift

class ForgotPasswordVM: BaseVM {
    var email: String = ""
    
    func handleForgetPassword() -> Observable<HandleStatus> {
        loadingData.accept(true)
        let requestForgetPasswordDto = RequestForgetPasswordDto(userNameOrEmail: email, callBackUrl: Configs.Server.forgotPasswordURL)
        
        return remoteRepository.forgotPassword(requestForgetPassword: requestForgetPasswordDto)
            .asObservable()
            .map { response in
                self.loadingData.accept(false)
                if 200...209 ~= response.statusCode {
                    return HandleStatus.Success
                } else {
                    return HandleStatus.Error(message: try response.mapString(atKeyPath: "message"))
                }
            }
            .catch { error in
                self.loadingData.accept(false)
                return Observable.just(HandleStatus.Error(message: error.localizedDescription))
            }
            .share()
            .observe(on: MainScheduler.instance)
    }
}
