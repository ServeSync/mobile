//
//  EventDAOImp.swift
//  PBL6
//
//  Created by KietKoy on 28/10/2023.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxRealm

class EventDAOImp: BaseDAO, EventDAO {
    func update(_ entity: REvent) -> RxSwift.Observable<FlatEventDto> {
        return Observable.deferred {
            let realm = self.realm
            return realm.rx.save(entity, update: true).map { $0.asModel() }
        }.observe(on: self.serialScheduler)
    }
    
    func save(_ entity: REvent) -> RxSwift.Observable<FlatEventDto> {
        return Observable.deferred {
            let realm = self.realm
            return realm.rx.save(entity).map { $0.asModel() }
        }.observe(on: self.serialScheduler)
    }
    
    func findAll() -> RxSwift.Observable<[FlatEventDto]> {
        return Observable.deferred {
            let realm = self.realm
            let objs = realm
                .objects(REvent.self)
            return Observable.array(from: objs)
                .map { $0.map { $0.asModel() } }
                .map { $0.reversed() }
                .observe(on: self.concurrentScheduler)
        }
    }
    
    func find(withId id: String) -> RxSwift.Observable<FlatEventDto?> {
        let predicate = NSPredicate(format: "id == %@", id)
        return Observable.deferred {
            let realm = self.realm
            let obj = realm
                .objects(REvent.self)
                .filter(predicate)
                .first
            return Observable.from(optional: obj)
                .map { $0.asModel() }
                .observe(on: self.concurrentScheduler)
        }
    }
    
    func deleteAll() -> Observable<Void> {
        return Observable.deferred {
            self.delete(self.realm
                .objects(REvent.self)
                .toArray())
        }.observe(on: self.serialScheduler)
    }
    
    func delete(withId id: String) -> Observable<Void> {
        let predicate = NSPredicate(format: "id == %@", id)
        return Observable.deferred {
            self.delete(self.realm
                .objects(REvent.self)
                .filter(predicate)
                .toArray())
        }.observe(on: self.serialScheduler)
    }
    
    func delete(_ entity: REvent) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.delete(entity)
        }.observe(on: self.serialScheduler)
    }
    
    func delete(_ entites: [REvent]) -> Observable<Void> {
        return Observable.deferred {
            let realm = self.realm
            return realm.rx.delete(entites)
        }.subscribe(on: self.serialScheduler)
    }
    
}


