//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Alamofire
import Moya

enum AppApi {
    //MARK: -- Demo
    case posts
    case search(params: [String : String])
    //MARK: -- App
    case signIn(usernameOrEmail: String, password: String)
    case profile
    case refreshToken(authCredentialDto: AuthCredentialDto)
    case profileDetail
    case forgetPassword(requestForgetPasswordDto: RequestForgetPasswordDto)
    case putProfile(studentEditProfileDto: StudentEditProfileDto)
}

extension AppApi: TargetType {
    
    var baseURL: URL {
        let urlString = Configs.Server.baseURL
        guard let url = URL(string: urlString) else { fatalError("Base URL Invalid") }
        return url
    }
    
    //MARK: -- path
    var path: String {
        switch self {
        case .posts:
            return "posts"
        case .search:
            return "novels"
        case .signIn:
            return "auth/sign-in"
        case .profile:
            return "profile"
        case .refreshToken:
            return "auth/refresh-token"
        case .profileDetail, .putProfile:
            return "profile/student"
        case .forgetPassword:
            return "auth/forget-password"
        }
    }
    
    //MARK: -- method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signIn, .refreshToken, .forgetPassword:
            return .post
        case .putProfile:
            return .put
        default:
            return .get
        }
    }
    
    //MARK: -- sampleData
    var sampleData: Data {
        return Data()
    }
    
    //MARK: -- task
    var task: Task {
        switch self {
        case .search(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case.signIn(let usernameOrEmail, let password):
            let body: [String: Any] = [
                            "userNameOrEmail": usernameOrEmail,
                            "password": password,
                        ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .refreshToken(let authCredentialDto):
            let body: [String: Any] = [
                "accessToken": authCredentialDto.accessToken,
                "refreshToken": authCredentialDto.refreshToken
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            } 
        case .forgetPassword(let requestForgetPasswordDto):
            let body: [String: Any] = [
                "userNameOrEmail": requestForgetPasswordDto.userNameOrEmail,
                "callBackUrl": requestForgetPasswordDto.callBackUrl
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .putProfile(let studentEditProfileDto):
            let body: [String: Any] = [
                "email": studentEditProfileDto.email,
                "phone": studentEditProfileDto.phone,
                "address": studentEditProfileDto.address,
                "homeTown": studentEditProfileDto.homeTown,
                "imageUrl": studentEditProfileDto.imageUrl
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        default:
            return .requestPlain
        }
    }
    
    //MARK: -- headers
    var headers: [String : String]? {
        switch self {
        case .signIn, .refreshToken:
            return [
                "Content-Type": "application/json; charset=utf-8"
            ]
        default:
            return [
                "Content-Type": "application/json; charset=utf-8",
                "Authorization": "Bearer \(UserDefaultHelper.shared.accessToken!)"
            ]
        }
    }
    
    //MARK: -- Authorization
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    
}
