//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Alamofire
import ObjectMapper

class AppNetworkImp: AppNetwork {
    
    let provider: NetworkProvider<AppApi>
    
    init() {
        let loggingPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        provider = NetworkProvider(session: NetworkConfig.shared, plugins: [loggingPlugin])
    }
    
    func requestWithoutMapping(_ target: AppApi) -> Single<Moya.Response> {
        return provider.request(target)
            .observe(on: MainScheduler.instance)
    }
    
    func request(_ target: AppApi) -> Single<Any> {
        return provider.request(target)
            .mapJSON()
            .observe(on: MainScheduler.instance)
    }
    
    func requestObject<T: BaseMappable, U: BaseMappable>(_ target: AppApi, 
                                                         successType: T.Type,
                                                         errorType: U.Type) -> Single<Result<T, U>> {
        return provider.request(target)
            .flatMap { response in
                if 200...299 ~= response.statusCode {
                    return self.provider.request(target)
                        .mapJSON()
                        .map { Mapper<T>().map(JSONObject: $0)! }
                        .map { Result<T, U>.success($0) }
                } else {
                    return self.provider.request(target)
                        .mapJSON()
                        .map { Mapper<U>().map(JSONObject: $0)! }
                        .map { Result<T, U>.failure($0) }
                }
            }
            .observe(on: MainScheduler.instance)
    }

    func requestObjectWithTokenRefresh<T: BaseMappable, U: BaseMappable>(_ target: AppApi, 
                                                                         successType: T.Type,
                                                                         errorType: U.Type) -> Single<Result<T, U>> {
        return provider.request(target)
            .flatMap { response -> Single<Result<T, U>> in
                if 200...299 ~= response.statusCode {
                    return self.provider.request(target)
                        .mapJSON()
                        .map { Mapper<T>().map(JSONObject: $0)! }
                        .map { Result<T, U>.success($0) }
                } else if response.statusCode == 401 {
                    return self.refreshTokenIfNeeded()
                        .flatMap { _ in
                            return self.requestObject(target, successType: successType, errorType: errorType)
                        }
                } else {
                    return self.provider.request(target)
                        .mapJSON()
                        .map { Mapper<U>().map(JSONObject: $0)! }
                        .map { Result<T, U>.failure($0) }
                }
            }
            .observe(on: MainScheduler.instance)
    }
    
    func refreshTokenIfNeeded() -> Single<Void> {
        return Single.create { single in
            let accessToken = UserDefaultHelper.shared.accessToken
            let refreshToken = UserDefaultHelper.shared.refreshToken
            
            guard let accessTokenValue = accessToken, let refreshTokenValue = refreshToken else {
                single(.failure("Error" as! Error))
                return Disposables.create()
            }
            
            let authCredentialDto = AuthCredentialDto(accessToken: accessTokenValue, refreshToken: refreshTokenValue)
            
            self.refreshToken(.refreshToken(authCredentialDto: authCredentialDto), errorType: ErrorResponse.self)
                .subscribe(onSuccess: { result in
                    switch result {
                    case .success(let data):
                        UserDefaultHelper.shared.accessToken = data.accessToken
                        UserDefaultHelper.shared.refreshToken = data.refreshToken
                        single(.success(()))
                    case .failure(let err):
                        single(.failure(err))
                    }
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: DisposeBag())
            
            return Disposables.create()
        }
    }
    
    func requestArray<T: BaseMappable>(_ target: AppApi, type: T.Type) -> Single<[T]> {
        return provider.request(target)
            .mapJSON()
            .map { Mapper<T>().mapArray(JSONObject: $0) }
            .observe(on: MainScheduler.instance)
            .flatMap {
                if let map = $0 {
                    return Single.just(map)
                } else {
                    return Single.error(NSError(domain: "Map object failed", code: 1, userInfo: nil))
                }
            }
    }
}

extension AppNetworkImp {
    func refreshToken<U: BaseMappable>(_ target: AppApi,
                                       errorType: U.Type) -> Single<Result<AuthCredentialDto, U>> {
        return provider.request(target)
            .flatMap { response in
                if 200...299 ~= response.statusCode {
                    return self.provider.request(target)
                        .mapJSON()
                        .map { Mapper<AuthCredentialDto>().map(JSONObject: $0)! }
                        .map { Result<AuthCredentialDto, U>.success($0) }
                } else {
                    return self.provider.request(target)
                        .mapJSON()
                        .map { Mapper<U>().map(JSONObject: $0)! }
                        .map { Result<AuthCredentialDto, U>.failure($0) }
                }
            }
            .observe(on: MainScheduler.instance)
    }
}
