//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

final class ApiServiceImp: ApiService {

    @Inject
    var appNetwork: AppNetwork
    
    //MARK: -- Demo
    
    func getPost() -> Single<[Post]> {
        return appNetwork.requestArray(.posts, type: Post.self)
    }
    
    //MARK: App

    
}
