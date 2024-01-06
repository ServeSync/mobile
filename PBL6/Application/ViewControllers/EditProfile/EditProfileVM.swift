//
//  EditProfileVM.swift
//  PBL6
//
//  Created by KietKoy on 01/10/2023.
//

import Foundation
import UIKit
import RxSwift

class EditProfileVM: BaseVM {
    var profileDetail: StudentDetailDto?
    var studentEditProfileDto: StudentEditProfileDto?
    var avtImage: UIImage?
    
    var homeTown: String = ""
    var address: String = ""
    var email: String = ""
    var phone: String = ""
    
    override init() {
        super.init()
    }
    
    func handleUpdateProfile() -> Observable<HandleStatus> {
        if let avtImage = avtImage {
            return handleUpdateProfileWithImage(avtImage)
        } else {
            return handleUpdateProfileWithoutImage()
        }
    }
    
    private func handleUpdateProfileWithImage(_ image: UIImage) -> Observable<HandleStatus> {
        return remoteRepository.postImage(image: image)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap { [weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil)) }
                
                switch result {
                case .success(let data):
                    studentEditProfileDto = StudentEditProfileDto(email: self.email,
                                                                      phone: self.phone,
                                                                      address: self.address,
                                                                      homeTown: self.homeTown,
                                                                      imageUrl: data.url)
                    return self.updateProfile(studentEditProfileDto: studentEditProfileDto!)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
    private func handleUpdateProfileWithoutImage() -> Observable<HandleStatus> {
        studentEditProfileDto = StudentEditProfileDto(email: self.email,
                                                          phone: self.phone,
                                                          address: self.address,
                                                          homeTown: self.homeTown,
                                                          imageUrl: profileDetail!.imageUrl)
        return updateProfile(studentEditProfileDto: studentEditProfileDto!)
    }
    
    private func updateProfile(studentEditProfileDto: StudentEditProfileDto) -> Observable<HandleStatus> {
        
        return remoteRepository.editProfile(studentEditProfileDto: studentEditProfileDto)
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
