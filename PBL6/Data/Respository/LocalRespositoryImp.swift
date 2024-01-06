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
    
    @Inject
    var eventDAO: EventDAO
    
    func getEvents() -> RxSwift.Observable<[FlatEventDto]> {
        return eventDAO.findAll()
    }
    
    func addSite(event: FlatEventDto) -> RxSwift.Observable<FlatEventDto> {
        return eventDAO.save(event.asRealm())
    }
    
    func deleteEvent(withId id: String) -> RxSwift.Observable<Void> {
        return eventDAO.delete(withId: id)
    }
    
    func deleteAllEvent() -> RxSwift.Observable<Void> {
        return eventDAO.deleteAll()
    }
    
    func findEventById(withId id: String) -> RxSwift.Observable<FlatEventDto?> {
        return eventDAO.find(withId: id)
    }
}

