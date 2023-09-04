//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation

protocol PermissionHelperDelegate {
    func allowed(_ item: Permission)
    func denied(_ item: Permission)
}
