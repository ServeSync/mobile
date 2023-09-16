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
            return "authen/sign-in"
        }
    }
    
    //MARK: -- method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signIn:
            return .post
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
//        case.signIn(let usernameOrEmail, let password):
//            let parameters: [String: Any] = [
//                            "userNameOrEmail": usernameOrEmail,
//                            "password": password
//                        ]
        default:
            return .requestPlain
        }
    }
    
    //MARK: -- headers
    var headers: [String : String]? {
        nil
    }
    
    //MARK: -- Authorization
    var authorizationType: AuthorizationType? {
        switch self {
        default:
            return nil
        }
    }
    
    
}
