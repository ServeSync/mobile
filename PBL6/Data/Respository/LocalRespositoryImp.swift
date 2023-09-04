//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import RxSwift

class LocalRespositoryImp: LocalRespository {
    
    @Inject
    var postDAO: PostDAO
    
    func getPosts() -> Observable<[Post]> {
        return postDAO.findAll()
    }
    
    func addSite(post: Post) -> RxSwift.Observable<Post> {
        return postDAO.save(post.asRealm())
    }
    
    func delete(withId id: Int) -> Observable<Void> {
        return postDAO.delete(withId: id)
    }
    
    func deleteAll() -> RxSwift.Observable<Void> {
        return postDAO.deleteAll()
    }
}

