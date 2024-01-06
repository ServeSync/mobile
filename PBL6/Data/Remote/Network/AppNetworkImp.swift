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
    func requestWithoutMappingWithRefreshToken(_ target: AppApi) -> Single<Moya.Response> {
        return Single.deferred {
            return self.provider.request(target)
                .flatMap {response in
                    if response.statusCode == 401 {
                        let accessToken = UserDefaultHelper.shared.accessToken!
                        let refreshToken = UserDefaultHelper.shared.refreshToken!
                        let authCredentialDto = AuthCredentialDto(accessToken: accessToken, refreshToken: refreshToken)
                        return self.refreshToken(.refreshToken(authCredentialDto: authCredentialDto), errorType: ErrorResponse.self)
                            .flatMap { authCredentialResult -> Single<Moya.Response> in
                                switch authCredentialResult {
                                case .success(let data):
                                    UserDefaultHelper.shared.accessToken = data.accessToken
                                    UserDefaultHelper.shared.refreshToken = data.refreshToken
                                    return self.requestWithoutMapping(target)
                                case .failure(let erorr):
                                    return Observable.just(erorr as! Response)
                                        .asSingle()
                                }
                            }
                    } else {
                        return Observable.just(response)
                            .asSingle()
                    }
                }
                .observe(on: MainScheduler.instance)
        }
    }
    
    func request(_ target: AppApi) -> Single<Any> {
        return provider.request(target)
            .mapJSON()
            .observe(on: MainScheduler.instance)
    }
    
    func requestObject<T: BaseMappable, U: BaseMappable>(_ target: AppApi,
                                                         successType: T.Type,
                                                         errorType: U.Type) -> Single<Result<T, U>> {
        return Single.deferred {
            return self.provider.request(target)
                .flatMap { response in
                    if 200...299 ~= response.statusCode {
                        return Observable.just(response)
                            .mapJSON()
                            .map { Mapper<T>().map(JSONObject: $0)! }
                            .map { Result<T, U>.success($0) }
                            .asSingle()
                    } else {
                        return Observable.just(response)
                            .mapJSON()
                            .map { Mapper<U>().map(JSONObject: $0)! }
                            .map { Result<T, U>.failure($0) }
                            .asSingle()
                    }
                }
                .observe(on: MainScheduler.instance)
        }
    }
    
    func requestObjectWithTokenRefresh<T: BaseMappable, U: BaseMappable>(_ target: AppApi,
                                                                         successType: T.Type,
                                                                         errorType: U.Type) -> Single<Result<T, U>> {
        
        return Single.deferred {
            return self.provider.request(target)
                .flatMap { response in
                    if 200...299 ~= response.statusCode {
                        return Observable.just(response)
                            .mapJSON()
                            .map { Mapper<T>().map(JSONObject: $0)! }
                            .map { Result<T, U>.success($0) }
                            .asSingle()
                    } else if response.statusCode == 401 {
                        let accessToken = UserDefaultHelper.shared.accessToken!
                        let refreshToken = UserDefaultHelper.shared.refreshToken!
                        let authCredentialDto = AuthCredentialDto(accessToken: accessToken, refreshToken: refreshToken)
                        return self.refreshToken(.refreshToken(authCredentialDto: authCredentialDto), errorType: errorType)
                            .flatMap { authCredentialResult -> Single<Result<T, U>> in
                                switch authCredentialResult {
                                case .success(let data):
                                    UserDefaultHelper.shared.accessToken = data.accessToken
                                    UserDefaultHelper.shared.refreshToken = data.refreshToken
                                    return self.requestObject(target, successType: successType, errorType: errorType)
                                case .failure(let error):
                                    return Single.just(Result<T, U>.failure(error))
                                }
                            }
                    } else {
                        return Observable.just(response)
                            .mapJSON()
                            .map { Mapper<U>().map(JSONObject: $0)! }
                            .map { Result<T, U>.failure($0) }
                            .asSingle()
                    }
                }
                .observe(on: MainScheduler.instance)
        }
    }
    
    func refreshToken<U: BaseMappable>(_ target: AppApi,
                                       errorType: U.Type) -> Single<Result<AuthCredentialDto, U>> {
        return Single.deferred {
            return self.provider.request(target)
                .flatMap { response in
                    if 200...299 ~= response.statusCode {
                        return Observable.just(response)
                            .mapJSON()
                            .map { Mapper<AuthCredentialDto>().map(JSONObject: $0)! }
                            .map { Result<AuthCredentialDto, U>.success($0) }
                            .asSingle()
                    } else {
                        return Observable.just(response)
                            .mapJSON()
                            .map { Mapper<U>().map(JSONObject: $0)! }
                            .map { Result<AuthCredentialDto, U>.failure($0) }
                            .asSingle()
                    }
                }
                .observe(on: MainScheduler.instance)
        }
    }
    
    func requestArray<T: BaseMappable, U: BaseMappable>(_ target: AppApi, 
                                                        successType: T.Type,
                                                        errorType: U.Type) -> Single<Result<[T], U>> {
        return Single.deferred {
            return self.provider.request(target)
                .flatMap { response in
                    if 200...299 ~= response.statusCode {
                        return Observable.just(response)
                            .mapJSON()
                            .map { Mapper<T>().mapArray(JSONObject: $0)! }
                            .map { Result<[T], U>.success($0) }
                            .asSingle()
                    } else {
                        return Observable.just(response)
                            .mapJSON()
                            .map { Mapper<U>().map(JSONObject: $0)! }
                            .map { Result<[T], U>.failure($0) }
                            .asSingle()
                    }
                }
                .observe(on: MainScheduler.instance)
        }
    }
}
