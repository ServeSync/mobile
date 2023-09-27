//
//  KeychainHelper.swift
//  PBL6
//
//  Created by KietKoy on 23/09/2023.
//

import Foundation
import ObjectMapper

final class KeychainHelper {
    
    static let shared = KeychainHelper()
    private init() {}
    
    func save<T>(_ item: T, service: String, account: String) where T : Encodable {
        
        do {
            let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)
            
        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }
    
    func read(service: String, account: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
//    func read<T>(service: String, account: String, type: T.Type) -> T? where T : Codable {
//        
//        guard let data = read(service: service, account: account) else {
//            return nil
//        }
//        
//        do {
//            let item = try JSONDecoder().decode(type, from: data)
//            return item
//        } catch {
//            assertionFailure("Fail to decode item for keychain: \(error)")
//            return nil
//        }
//    }
    
    func read<T>(service: String, account: String, type: T.Type) -> T? where T: Mappable {
        
        // Read item data from keychain
        guard let data = read(service: service, account: account) else {
            return nil
        }
        
        // Attempt to map the data to the specified object type
        if let jsonString = String(data: data, encoding: .utf8),
           let item = Mapper<T>().map(JSONString: jsonString) {
            return item
        } else {
            assertionFailure("Fail to map item for keychain")
            return nil
        }
    }

}
