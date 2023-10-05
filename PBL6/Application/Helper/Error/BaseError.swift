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
    //MARK: - User
    case userWithIdNotFound = "User:000001"
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
    case permissionDontAllowLoginForApp = "Permission:01"
    
    //MARK: - Student
    case duplicateStudentCode = "Student:000001"
    case duplicateCitizenIdentifier = "Student:000002"
    case studentWithIdNotFound = "Student:000003"
    case duplicateStudentEmail = "Student:000004"
    case duplicateIdentityIdentifier = "Student:000005"
    case identityIdentifierNotFound = "Student:000006"
    
    //MARK: - Faculty
    case duplicateFacultyName = "Faculty:000001"
    case facultyNotFound = "Faculty:000002"
    
    //MARK: - EducationProgram
    case duplicateEducationProgramName = "EducationProgram:000001"
    case educationProgramNotFound = "EducationProgram:000002"
    
    //MARK: - HomeRoom
    case duplicateHomeRoomName = "HomeRoom:000001"
    case homeRoomNotFound = "HomeRoom:000002"
    
    var description: String {
        switch self {
        case .userNotFound:
            return "User with given username or email does not exist"
        case .accountLocked:
            return "Account has been locked out"
        case .incorrectPassword:
            return "Incorrect password"
        case .refreshTokenExpired:
            return "Refresh token has already expired"
        case .refreshTokenNotFound:
            return "Refresh token does not exist"
        case .refreshTokenAlreadyAdded:
            return "Refresh token has already been added to user"
        case .accessTokenValid:
            return "Access token is still valid"
        case .roleNotFound:
            return "Role with given id does not exist"
        case .permissionAlreadyGranted:
            return "Permission has already been granted to role"
        case .permissionNotGrantedYet:
            return "Permission has not been granted to role yet"
        case .cannotModifyAdminRole:
            return "Cannot create, update, or delete 'Admin' role"
        case .userWithIdNotFound:
            return "User with given id does not exist"
        case .permissionNotFound:
            return "Permission with given id does not exist"
        case .permissionDontAllowLoginForApp:
            return "permission_dont_allow_login_for_appr".localized
        case .duplicateStudentCode:
            return "Student with the given code already exists"
        case .duplicateCitizenIdentifier:
            return "Student with the given citizen identifier already exists"
        case .studentWithIdNotFound:
            return "Student with given id does not exist"
        case .duplicateStudentEmail:
            return "Student with the given email has already existed"
        case .duplicateIdentityIdentifier:
            return "Identity identifier for student has already existed"
        case .identityIdentifierNotFound:
            return "Student with identity identifier does not exist"
        case .duplicateFacultyName:
            return "Faculty with the given name has already existed"
        case .facultyNotFound:
            return "Faculty with given id does not exist"
        case .duplicateEducationProgramName:
            return "Education program with the given name has already existed"
        case .educationProgramNotFound:
            return "Education program with given id does not exist"
        case .duplicateHomeRoomName:
            return "Home room with the given name has already existed"
        case .homeRoomNotFound:
            return "Home room with given id does not exist"
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

