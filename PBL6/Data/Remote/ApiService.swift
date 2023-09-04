//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Foundation
import RxSwift

protocol ApiService {
    func getPost() -> Single<[Post]>
}
