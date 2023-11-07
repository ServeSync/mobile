//
//  RollCall.swift
//  PBL6
//
//  Created by KietKoy on 02/11/2023.
//

import Foundation
import RxSwift

class RollCallVM: BaseVM {
    func rollCall(code: String, eventId: String, latitude: Double, longitude: Double) -> Observable<HandleStatus> {
        let studentAttendEventDto = StudentAttendEventDto(code: code, latitude: latitude, longitude: longitude)
        return remoteRepository.rollcallEvent(studentAttendEventDto: studentAttendEventDto, eventId: eventId)
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
                return Observable.just(.Error(error: error as? ErrorResponse))
            }
    }
}
