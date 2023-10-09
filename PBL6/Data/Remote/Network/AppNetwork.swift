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
import ObjectMapper

protocol AppNetwork {
    func requestWithoutMapping(_ target: AppApi) -> Single<Moya.Response>
    func requestWithoutMappingWithRefreshToken(_ target: AppApi) -> Single<Moya.Response>
    func request(_ target: AppApi) -> Single<Any>
    func requestObject<T: BaseMappable, U: BaseMappable>(_ target: AppApi, 
                                                         successType: T.Type,
                                                         errorType: U.Type) -> Single<Result<T, U>>
    func requestObjectWithTokenRefresh<T: BaseMappable, U: BaseMappable>(_ target: AppApi,
                                                                         successType: T.Type,
                                                                         errorType: U.Type) -> Single<Result<T, U>>
    func requestArray<T: BaseMappable>(_ target: AppApi, type: T.Type) -> Single<[T]>
    func refreshToken<U: BaseMappable>(_ target: AppApi,
                                       errorType: U.Type) -> Single<Result<AuthCredentialDto, U>>
}
