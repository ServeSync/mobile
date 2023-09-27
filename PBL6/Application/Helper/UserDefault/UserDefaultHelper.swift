//
//  UserDefaultHelper.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation

private enum UserDefaultKey {
    static let firstLaunchApp = "firstLaunchApp"
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
}

class UserDefaultHelper {
    static let shared = UserDefaultHelper()
    
    private init() {
        if UserDefaults.standard.object(forKey: UserDefaultKey.firstLaunchApp) == nil {
            UserDefaults.standard.set(true, forKey: UserDefaultKey.firstLaunchApp)
        }
    }

    var firstLaunchApp: Bool {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.firstLaunchApp)
        }
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultKey.firstLaunchApp)
        }
    }
    
    var accessToken: String? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.accessToken)
        }
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKey.accessToken) ?? ""
        }
    }
    
    var refreshToken: String? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.refreshToken)
        }
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKey.refreshToken)
        }
    }
}
