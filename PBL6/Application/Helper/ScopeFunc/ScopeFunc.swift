//
//  File.swift
//  PBL6
//
//  Created by KietKoy on 02/09/2023.
//

import Foundation

/// Scope functions
protocol ScopeFunc { }

extension ScopeFunc {
  /// Calls the specified function block with self value as its argument and returns self value.
  @inline(__always) func apply(block: (Self) -> ()) -> Self {
    block(self)
    return self
  }

  /// Calls the specified function block with self value as its argument and returns its result.
  @discardableResult
  @inline(__always) func letIt<R>(block: (Self) -> R) -> R {
    return block(self)
  }
}

extension NSObject: ScopeFunc { }

