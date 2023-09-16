//
//  AuthenApiService.swift
//  PBL6
//
//  Created by KietKoy on 16/09/2023.
//

import Foundation
import RxSwift

protocol AuthenApiService {
    func signIn(userNameOrPassword: String, password: String) -> Single<SignInResponse>
}
