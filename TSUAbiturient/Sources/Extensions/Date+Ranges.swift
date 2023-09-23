//
//  Date+Ranges.swift
//  TSUAbiturient
//

import Foundation

extension Date {
  static var calendarISO: Calendar {
    Calendar(identifier: .iso8601)
  }

  func startOfWeek() -> Date? {
    return Self.calendarISO.dateComponents([.calendar, .weekOfYear, .yearForWeekOfYear], from: self).date
  }

  func endOfWeek() -> Date? {
    guard let date = startOfWeek() else {
      return nil
    }
    return Self.calendarISO.date(byAdding: .day, value: 6, to: date)
  }
  
  func dayOfWeek() -> Int {
    var dayOfWeek = Self.calendarISO.component(.weekday, from: self) - Self.calendarISO.firstWeekday + 1
    if dayOfWeek <= 0 {
      dayOfWeek += 7
    }
    return dayOfWeek
  }

  func startOfMonth() -> Date? {
    return Self.calendarISO.dateComponents([.calendar, .year, .month], from: self).date
  }

  func endOfMonth() -> Date? {
    guard let startOfMonth = startOfMonth() else { return nil }
    return Self.calendarISO.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
  }
}
