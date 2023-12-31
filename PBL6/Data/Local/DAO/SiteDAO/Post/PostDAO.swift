//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import RxSwift
import Realm

protocol PostDAO {
    func findAll() -> Observable<[Post]>
    func find(withId id: Int) -> Observable<Post?>
    func save(_ entity: RPost) -> Observable<Post>
    func update(_ entity: RPost) -> Observable<Post>
    func deleteAll() -> Observable<Void>
    func delete(withId id: Int) -> Observable<Void>
    func delete(_ entity: RPost) -> Observable<Void>
    func delete(_ entites: [RPost]) -> Observable<Void>
}
