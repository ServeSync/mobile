//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Foundation
import Moya
import RxSwift
import Alamofire

class NetworkProvider<Target> where Target: TargetType {
    fileprivate let online: Observable<Bool>
    fileprivate let provider: MoyaProvider<Target>
    private let authToken: String?
    
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
         session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false,
         online: Observable<Bool> = connectedToInternet(),
         authToken: String? = nil) {
        self.online = online
        self.authToken = authToken
//        self.provider = MoyaProvider(endpointClosure: endpointClosure,
//                                     requestClosure: requestClosure,
//                                     stubClosure: stubClosure,
//                                     session: session,
//                                     plugins: plugins,
//                                     trackInflights: trackInflights)
        self.provider = MoyaProvider(endpointClosure: { (target: Target) -> Endpoint in
            let defaultEndpoint = endpointClosure(target)
            if let authToken = authToken {
                return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Bearer \(authToken)"])
            } else {
                return defaultEndpoint
            }
        }, requestClosure: requestClosure, stubClosure: stubClosure, session: session, plugins: plugins, trackInflights: trackInflights)
    }
    
    func request(_ token: Target) -> Single<Moya.Response> {
        return self.provider.rx.request(token)
    }
}
