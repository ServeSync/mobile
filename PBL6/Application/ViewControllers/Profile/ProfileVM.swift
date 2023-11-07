//
//  ProfileVM.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import Foundation
import RxSwift

class ProfileVM: BaseVM {
    
    let profileDetailData = PublishData<StudentDetailDto>()
    var profileDetail: StudentDetailDto?
    
    func fetchData() -> Observable<HandleStatus>{

        return remoteRepository.getProfileDetail()
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .flatMap{ [weak self] result -> Observable<HandleStatus> in
                guard let self = self else { return .just(.Error(error: nil))}
                switch result {
                case .success(let data):
                    profileDetailData.accept(data)
                    profileDetail = data
                    return .just(.Success)
                case .failure(let error):
                    return .just(.Error(error: error))
                }
            }
    }
    
    func updateData(studentEditProfileDto: StudentEditProfileDto) {
        profileDetail?.imageUrl = studentEditProfileDto.imageUrl
        profileDetail?.phone = studentEditProfileDto.phone
        profileDetail?.address = studentEditProfileDto.address
        profileDetail?.homeTown = studentEditProfileDto.homeTown
        profileDetail?.email = studentEditProfileDto.email
        
        profileDetailData.accept(profileDetail)
    }
}
