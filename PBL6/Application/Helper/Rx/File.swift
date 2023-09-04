//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import RxSwift

class PublishData<T>: ObservableType {
    
    private let subject: PublishSubject<T>
    
    ///make sure the data is never nil
    public private(set) var data : T!

    /// Initializes with internal empty subject.
    public init() {
        subject = PublishSubject()
    }
    
    public init(_ initData: T) {
        subject = PublishSubject()
        self.data = initData
    }
    
    public func accept(_ data : T!) {
        self.data = data
        subject.onNext(data)
    }
    
    /// Subscribes observer
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == T {
        return subject.subscribe(observer)
    }
    
    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<T> {
        return subject.asObservable()
    }
    
    public func dispose() {
        subject.dispose()
    }
}
