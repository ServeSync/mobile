//
//  BaseError.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import Foundation

protocol BaseError: Error {
    var description: String { get set }
}
