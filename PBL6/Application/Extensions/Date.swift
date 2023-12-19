//
//  Date.swift
//  PBL6
//
//  Created by KietKoy on 04/12/2023.
//

import Foundation

extension Date {
    func isSameDate(_ comparisonDate: Date) -> Bool {
      let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
      return order == .orderedSame
    }

    func isBeforeDate(_ comparisonDate: Date) -> Bool {
      let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
      return order == .orderedAscending
    }

    func isAfterDate(_ comparisonDate: Date) -> Bool {
      let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
      return order == .orderedDescending
    }
}
