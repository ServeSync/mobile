//
//  RemoteRespository.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import RxSwift

protocol RemoteRepository {
    //Demo
    func getPosts() -> Single<[Post]>
    
    //App
}
