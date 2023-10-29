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
    func findAll() -> Observable<[EventDetailDto]>
    func find(withId id: Int) -> Observable<EventDetailDto?>
    func delete(withId id: Int) -> Observable<Void>
    func update(_ entity: RPost) -> Observable<EventDetailDto>
    func save(_ entity: RPost) -> Observable<EventDetailDto>
}
