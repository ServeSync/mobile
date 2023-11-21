//
//  ChangePasswordVM.swift
//  PBL6
//
//  Created by KietKoy on 20/11/2023.
//

import Foundation
import RxSwift

class ChangePasswordVM: BaseVM {
    var oldPassword: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""
    
    func handleChangePassword() -> Observable<HandleStatus> {
        let changePassworDto = ChangePassworDto(currentPassword: self.oldPassword, newPassword: self.newPassword)
        
        return remoteRepository.changePassword(changePassworDto: changePassworDto)
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
            .catch { error in
                return Observable.just(.Error(error: error as? ErrorResponse))
            }
    }
}
