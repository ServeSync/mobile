//
//  Inject.swift
//  PBL6
//
//  Created by KietKoy on 30/08/2023.
//

import Foundation
import Swinject

@propertyWrapper
public struct Inject<Value> {
  private(set) public var wrappedValue: Value
  
  public init() {
      self.wrappedValue = DI.shared.resolve()
  }
}
