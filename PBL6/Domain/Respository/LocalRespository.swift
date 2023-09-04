//
//  LocalRespository.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import RxSwift

protocol LocalRespository {
    func getPosts() -> Observable<[Post]>
    func addSite(post: Post) -> Observable<Post>
    func delete(withId id: Int) -> Observable<Void>
    func deleteAll() -> Observable<Void>
}
