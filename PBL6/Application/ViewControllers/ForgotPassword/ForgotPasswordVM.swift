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
                if 200...299 ~= response.statusCode {
                    return HandleStatus.Success
                } else {
                    let errorCode = try response.mapString(atKeyPath: "code")
                    let message = try response.mapString(atKeyPath: "message")
                    return HandleStatus.Error(error: ErrorResponse(code: errorCode, message: message))
                }
            }
            .catch { error in
                self.loadingData.accept(false)
                return Observable.just(HandleStatus.Error(error: error as? ErrorResponse))
            }
    }
}
