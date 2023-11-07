//
//  RegisterVM.swift
//  PBL6
//
//  Created by KietKoy on 02/11/2023.
//

import Foundation
import RxSwift

class RegisterVM: BaseVM {
    var data = [EventRoleDto]()
    
    let dataS = PublishData<[EventRoleDto]>()
    
    var selectedItem: EventRoleDto? = nil
    
    func fetchData() {
        let tempData = data.filter( {$0.isRegistered == false})
        if let item = tempData.first {
            selectedItem(item: item)
        } else {
            dataS.accept(tempData)
        }
    }
    
    func selectedItem(item: EventRoleDto) {
        selectedItem = item
        
        for index in 0..<data.count {
            if data[index].id == item.id {
                data[index].isSelected = true
            } else {
                data[index].isSelected = false
            }
        }
        
        dataS.accept(data.filter( {$0.isRegistered == false}))
    }
    
    func registerEvent(eventRoleId: String, description: String) -> Observable<HandleStatus> {
        let eventRegisterDto = EventRegisterDto(eventRoleId: eventRoleId, description: description)
        
        return remoteRepository.registerEvent(eventRegisterDto: eventRegisterDto)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { response in
                if 200...299 ~= response.statusCode {
                    return .Success
                } else {
                    let errorCode = try response.mapString(atKeyPath: "code")
                    let message = try response.mapString(atKeyPath: "message")
                    return .Error(error: ErrorResponse(code: errorCode, message: message))
                }
            }
            .catch { error in
                return Observable.just(HandleStatus.Error(error: error as? ErrorResponse))
            }
    }
}
