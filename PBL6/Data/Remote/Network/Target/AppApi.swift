//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Alamofire
import Moya

enum AppApi {
    //MARK: -- Demo
    case posts
    case search(params: [String : String])
    
    //MARK: -- Auth
    case signIn(usernameOrEmail: String, password: String)
    case refreshToken(authCredentialDto: AuthCredentialDto)
    case forgetPassword(requestForgetPasswordDto: RequestForgetPasswordDto)
    case changePassword(changePassworDto: ChangePassworDto)
    
    //MARK: - profile
    case profile
    case profileDetail
    case putProfile(studentEditProfileDto: StudentEditProfileDto)
    case postImage(image: UIImage)
    
    //MARK: - Student
    case getEducationProgam
    case getAttendanceEvents(page: Int)
    case exportFile(exportStudentAttendanceEventsDto: ExportStudentAttendanceEventsDto)
    
    //MARK: - Event
    case getEventsByStatus(status: EventStatus, page: Int)
    case searchEvent(keyword: String, page: Int)
    case getEventById(id: String)
    case registerEvent(eventRegisterDto: EventRegisterDto)
    case rollcallEvent(studentAttendEventDto: StudentAttendEventDto, eventId: String)
    case getEventRegistered(studentId: String)
    case getAllYourEvents
    case getEventActivities(type: EventActivityType)
    
    //MARK: - Proof
    case postProofInternal(internalProofCreateDto: InternalProofCreateDto)
    case postProofExternal(externalProofCreateDto: ExternalProofCreateDto)
    case postProofSpecial(specialProofCreateDto: SpecialProofCreateDto)
    case getProofs
    case deleteProof(id: String)
    case getProofDetail(id: String)
}

extension AppApi: TargetType {
    
    var baseURL: URL {
        let urlString = Configs.Server.baseURL
        guard let url = URL(string: urlString) else { fatalError("Base URL Invalid") }
        return url
    }
    
    //MARK: -- path
    var path: String {
        switch self {
        case .posts:
            return "posts"
        case .search:
            return "novels"
        case .signIn:
            return "auth/student-portal/sign-in"
        case .profile:
            return "profile"
        case .changePassword:
            return "profile/change-password"
        case .refreshToken:
            return "auth/refresh-token"
        case .profileDetail, .putProfile:
            return "profile/student"
        case .forgetPassword:
            return "auth/forget-password"
        case .postImage:
            return "images"
        case .getEventsByStatus, .searchEvent, .getAllYourEvents:
            return "events"
        case .getEventById(let id):
            return "events/\(id)"
        case .registerEvent:
            return "events/register"
        case .rollcallEvent(_, let eventId):
            return "events/\(eventId)/event-attendances"
        case .getEventRegistered(let studentId):
            return "students/\(studentId)/registered-events"
        case .getEducationProgam:
            return "students/\(UserDefaultHelper.shared.studentId!)/education-program"
        case .getAttendanceEvents:
            return "students/\(UserDefaultHelper.shared.studentId!)/attendance-events"
        case .exportFile:
            return "students/\(UserDefaultHelper.shared.studentId!)/attendance-events/export"
        case .postProofInternal:
            return "proofs/internal"
        case .postProofExternal:
            return "proofs/external"
        case .postProofSpecial:
            return "proofs/special"
        case .getProofs:
            return "proofs/\(UserDefaultHelper.shared.studentId!)/student"
        case .deleteProof(let id):
            return "proofs/\(id)"
        case .getProofDetail(let id):
            return "proofs/\(id)"
        case .getEventActivities:
            return "event-activities"
        }
    }
    
    //MARK: -- method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signIn, .refreshToken, .forgetPassword, .postImage, .registerEvent, .rollcallEvent, .changePassword, .exportFile, .postProofInternal, .postProofExternal, .postProofSpecial:
            return .post
        case .putProfile:
            return .put
        case .deleteProof:
            return .delete
        default:
            return .get
        }
    }
    
    //MARK: -- sampleData
    var sampleData: Data {
        return Data()
    }
    
    //MARK: -- task
    var task: Task {
        switch self {
        case .search(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case.signIn(let usernameOrEmail, let password):
            let body: [String: Any] = [
                            "userNameOrEmail": usernameOrEmail,
                            "password": password,
                        ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .refreshToken(let authCredentialDto):
            let body: [String: Any] = [
                "accessToken": authCredentialDto.accessToken,
                "refreshToken": authCredentialDto.refreshToken
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            } 
        case .forgetPassword(let requestForgetPasswordDto):
            let body: [String: Any] = [
                "userNameOrEmail": requestForgetPasswordDto.userNameOrEmail,
                "callBackUrl": requestForgetPasswordDto.callBackUrl
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .putProfile(let studentEditProfileDto):
            let body: [String: Any] = [
                "email": studentEditProfileDto.email,
                "phone": studentEditProfileDto.phone,
                "address": studentEditProfileDto.address,
                "homeTown": studentEditProfileDto.homeTown,
                "imageUrl": studentEditProfileDto.imageUrl
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .postImage(let image):
            let imageData = image.jpegData(compressionQuality: 0.1)
            let formData = MultipartFormData(provider: .data(imageData!), name: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            return .uploadMultipart([formData])
        case .getEventsByStatus(let status, let page):
            let params: [String: Any] = [
                "Page": page,
                "EventStatus": status.rawValue
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .registerEvent(let eventRegisterDto):
            let body: [String: Any] = [
                "eventRoleId": eventRegisterDto.eventRoleId,
                "description": eventRegisterDto.description
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .rollcallEvent(let studentAttendEventDto, _):
            let body: [String: Any] = [
                "code": studentAttendEventDto.code,
                "latitude": studentAttendEventDto.latitude,
                "longitude": studentAttendEventDto.longitude
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .searchEvent(let keyword, let page):
            let params: [String: Any] = [
                "Page": page,
                "Search": keyword
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getAttendanceEvents(let page):
            let params: [String: Any] = [
                "Page": page,
                "Size": 10
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .changePassword(let changePassworDto):
            let body: [String: Any] = [
                "currentPassword": changePassworDto.currentPassword,
                "newPassword": changePassworDto.newPassword,
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .exportFile(let exportStudentAttendanceEventsDto):
            let body: [String: Any] = [
                "fromDate": exportStudentAttendanceEventsDto.fromDate,
                "toDate": exportStudentAttendanceEventsDto.toDate,
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .getEventRegistered:
            let params: [String: Any] = [
                "Page": 1,
                "Size": 100
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .postProofInternal(let internalProofCreateDto):
            let body: [String: Any] = [
                "eventId": internalProofCreateDto.eventId,
                "eventRoleId": internalProofCreateDto.eventRoleId,
                "description": internalProofCreateDto.description,
                "imageUrl": internalProofCreateDto.imageUrl,
                "attendanceAt": internalProofCreateDto.attendanceAt,
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .postProofExternal(let externalProofCreateDto):
            let body: [String: Any] = [
                "eventName": externalProofCreateDto.eventName,
                "address": externalProofCreateDto.address,
                "organizationName": externalProofCreateDto.organizationName,
                "role": externalProofCreateDto.role,
                "score": externalProofCreateDto.score,
                "attendanceAt": externalProofCreateDto.attendanceAt,
                "startAt": externalProofCreateDto.startAt,
                "endAt": externalProofCreateDto.endAt,
                "activityId": externalProofCreateDto.activityId,
                "description": externalProofCreateDto.description,
                "imageUrl": externalProofCreateDto.imageUrl,
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .getAllYourEvents:
            let params: [String: Any] = [
                "IsPaging": "false"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .postProofSpecial(let specialProofCreateDto):
            let body: [String: Any] = [
                "title": specialProofCreateDto.title,
                "role": specialProofCreateDto.role,
                "score": specialProofCreateDto.score,
                "startAt": specialProofCreateDto.startAt,
                "endAt": specialProofCreateDto.endAt,
                "activityId": specialProofCreateDto.activityId,
                "description": specialProofCreateDto.description,
                "imageUrl": specialProofCreateDto.imageUrl
            ]
            if let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                return .requestData(jsonBody)
            } else {
                return .requestPlain
            }
        case .getEventActivities(let type):
            let params: [String: Any] = [
                "Type": type,
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    //MARK: -- headers
    var headers: [String : String]? {
        switch self {
        case .signIn, .refreshToken:
            return [
                "Content-Type": "application/json; charset=utf-8"
            ]
        case .postImage:
            return [
                "Content-Type": "multipart/form-data;"
            ]
        default:
            return [
                "Content-Type": "application/json; charset=utf-8",
                "Authorization": "Bearer \(UserDefaultHelper.shared.accessToken!)"
            ]
        }
    }
    
    //MARK: -- Authorization
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
}
