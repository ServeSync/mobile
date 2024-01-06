//
//  BaseError.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import Foundation

protocol BaseError: Error {
    var description: String { get set }
}

enum AppError: String {
    //MARK: - Auth
    case userNotFound = "User:000002"
    case accountLocked = "User:000003"
    case incorrectPassword = "User:000004"
    case refreshTokenExpired = "User:000005"
    case refreshTokenNotFound = "User:000006"
    case refreshTokenAlreadyAdded = "User:000007"
    case accessTokenValid = "User:000008"
    
    //MARK: - Role
    case roleNotFound = "Role:000001"
    case permissionAlreadyGranted = "Role:000002"
    case permissionNotGrantedYet = "Role:000003"
    case cannotModifyAdminRole = "Role:000004"
    
    //MARK: - Permission
    case permissionNotFound = "Permission:000001"
    
    //MARK: - Student
    case studentRegistered = "Student:000007"
    case studentAccepted = "Student:000008"
    case studentCheckedIn = "Student:000009"
    case studentNotApproved = "Student:000010"
    case studentNotWithin200mRadius = "Student:000011"
    case registrationRequestNotApproved = "Student:000012"
    case registrationRequestNotFound = "Student:000013"
    
    //MARK: - EventAttendanceInfo
    case duplicateCheckInTime = "EventAttendanceInfo:000001"
    case checkInTimeLessThan15Minutes = "EventAttendanceInfo:000002"
    case checkInTimeNotWithinEventTime = "EventAttendanceInfo:000003"
    case checkInTimeFrameNotFound = "EventAttendanceInfo:000004"
    case invalidCheckInCode = "EventAttendanceInfo:000005"
    
    //MARK: - Event
    case eventNotExist = "Event:000003"
    
    var description: String {
        switch self {
        case .userNotFound:
            return "userNotFound".localized
        case .accountLocked:
            return "accountLocked".localized
        case .incorrectPassword:
            return "incorrectPassword".localized
        case .refreshTokenExpired:
            return "refreshTokenExpired".localized
        case .refreshTokenNotFound:
            return "refreshTokenNotFound".localized
        case .refreshTokenAlreadyAdded:
            return "refreshTokenAlreadyAdded".localized
        case .accessTokenValid:
            return "accessTokenValid".localized
        case .roleNotFound:
            return "roleNotFound".localized
        case .permissionAlreadyGranted:
            return "permissionAlreadyGranted".localized
        case .permissionNotGrantedYet:
            return "permissionNotGrantedYet".localized
        case .cannotModifyAdminRole:
            return "cannotModifyAdminRole".localized
        case .permissionNotFound:
            return "permissionNotFound".localized
        case .studentRegistered:
            return "studentRegistered".localized
        case .studentAccepted:
            return "studentAccepted".localized
        case .studentCheckedIn:
            return "studentCheckedIn".localized
        case .studentNotApproved:
            return "studentNotApproved".localized
        case .studentNotWithin200mRadius:
            return "studentNotWithin200mRadius".localized
        case .registrationRequestNotApproved:
            return "registrationRequestNotApproved".localized
        case .registrationRequestNotFound:
            return "registrationRequestNotFound".localized
        case .duplicateCheckInTime:
            return "duplicateCheckInTime".localized
        case .checkInTimeLessThan15Minutes:
            return "checkInTimeLessThan15Minutes".localized
        case .checkInTimeNotWithinEventTime:
            return "checkInTimeNotWithinEventTime".localized
        case .checkInTimeFrameNotFound:
            return "checkInTimeFrameNotFound".localized
        case .invalidCheckInCode:
            return "invalidCheckInCode".localized
        case .eventNotExist:
            return "eventNotExist".localized
        }
    }
}

func getErrorDescription(forErrorCode errorCode: String) -> String {
    if let errorCase = AppError(rawValue: errorCode) {
        return errorCase.description
    } else {
        return "Unknown error"
    }
}

