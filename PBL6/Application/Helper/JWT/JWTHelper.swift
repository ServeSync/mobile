//
//  JWTHelper.swift
//  PBL6
//
//  Created by KietKoy on 04/09/2023.
//

import Foundation
import JWTDecode
import ObjectMapper

class JWTHelper {

    static func decodeAndMap<T: Mappable>(jwtToken: String, to objectType: T.Type) -> T? {
        do {
            let jwt = try decode(jwt: jwtToken)
            if let payload = jwt.body as? [String: Any] {
                let object = Mapper<T>().map(JSONObject: payload)
                return object
            }
        } catch {
            // Handle decoding errors
            print("Error decoding JWT token: \(error)")
        }
        return nil
    }
}
