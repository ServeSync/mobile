//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import RxSwift
import RxSwiftExt

final class RemoteRepositoryImp: RemoteRepository {
    
    @Inject
    var apiService: ApiService!
    
    func getPosts() -> Single<[Post]> {
        return apiService.getPost()
    }
}
