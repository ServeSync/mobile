//
//  EventDAO.swift
//  PBL6
//
//  Created by KietKoy on 28/10/2023.
//

import Foundation
import RxSwift
import Realm

protocol EventDAO {
    func findAll() -> Observable<[FlatEventDto]>
    func find(withId id: String) -> Observable<FlatEventDto?>
    func delete(withId id: String) -> Observable<Void>
    func update(_ entity: REvent) -> Observable<FlatEventDto>
    func save(_ entity: REvent) -> Observable<FlatEventDto>
    func deleteAll() -> Observable<Void>
}
