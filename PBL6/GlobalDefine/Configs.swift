//
//  Configs.swift
//  PBL6
//
//  Created by KietKoy on 01/09/2023.
//

import Foundation
import UIKit

enum Configs {
    
    //MARK: -- Server
    enum Server {
        static let baseURL = "https://jsonplaceholder.typicode.com/"
    }
    
    //MARK: -- Network
    enum Network {
        static let perPage = 10
        static let networkTimeout:Double = 30 //second
        static let appOpenAdsLoadTimeout: TimeInterval = 15
    }
}

//MARK: Read: AppDebug.plist or AppRelease.plist
//Load info configs from file App plist
fileprivate class AppConfigs {
    
    fileprivate static let shared = AppConfigs()
    private var servers : [String: Any] = [:]
    
    fileprivate init() {
        readAppConfigInfo()
    }
    
    //MARK: AppConfigs read file
    private func readAppConfigInfo() {
        servers = Configs.stringValue(forKey: "Server") as! [String : Any]
    }
}

extension Configs {
    static func stringValue(forKey key: String) -> Any {
        guard let appConfigs = Bundle.main.object(forInfoDictionaryKey: "AppConfigs") as? Dictionary<String, Any>
        else {
            fatalError("Invalid value or undefined key")
        }
        guard let value = appConfigs[key]
        else {
            fatalError("Invalid value or undefined key")
        }
        return value
    }
}

