//
//  TimeInterval+FormattedTime.swift
//  TSUAbiturient
//

import Foundation

extension TimeInterval {
  func formattedTime() -> String {
    let formatter = DateFormatter.shortHoursMinutes
    return formatter.string(from: Date(timeIntervalSince1970: self))
  }
  
  func formattedDate() -> String {
    let formatter = DateFormatter.dayMonthYearDisplay
    return formatter.string(from: Date(timeIntervalSince1970: self))
  }
}
