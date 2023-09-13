//
//  UserDefaultHelper.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation

private enum UserDefaultKey {
    static let firstLaunchApp = "firstLaunchApp"
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
}
