//
//  BaseVM.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import RxSwift
import RxSwift
import RxCocoa

class BaseVM: NSObject {
    let trigger = PublishRelay<Void>()
    let indicatorLoading = ActivityIndicator()
    let errorTracker = ErrorTracker()
    let loadingData = PublishData<Bool>()
    let messageData = PublishData<AlertMessage>()
    
    @Inject
    var remoteRepository: RemoteRepository
//    @Inject
//    var localRespository: LocalRespository
    
    let bag = DisposeBag()
    
    override init() {
        super.init()
        
        listenerEvents()
        
        print("init viewmodel :: >>>> \(String(describing: self)) <<<<")
    }
    
    func listenerEvents()  {}
    
    deinit {
        print("deinit viewmodel :: >>>> \(String(describing: self)) <<<<")
    }
}

