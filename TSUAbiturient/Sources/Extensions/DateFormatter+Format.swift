//
//  DateFormatter+Format.swift
//  TSUAbiturient
//

import Foundation

private extension Constants {
  static let dayOfWeek = "E"
  static let dayOfMonth = "d"
  static let fullMonthYear = "LLLL yyyy"
  static let yearMonthDayISO = "yyyy-MM-dd"
  static let shortHoursMinutes = "H:mm"
  static let dayMonthDisplay = "d MMMM"
  static let dayMonthYearDisplay = "d MMMM yyyy"
}

extension DateFormatter {
  static let dayOfWeek = dateFormatter(format: Constants.dayOfWeek)
  static let dayOfMonth = dateFormatter(format: Constants.dayOfMonth)
  static let fullMonthYear = dateFormatter(format: Constants.fullMonthYear)
  static let yearMonthDayISO = dateFormatter(format: Constants.yearMonthDayISO)
  static let shortHoursMinutes = dateFormatter(format: Constants.shortHoursMinutes)
  static let dayMonthDisplay = dateFormatter(format: Constants.dayMonthDisplay)
  static let dayMonthYearDisplay = dateFormatter(format: Constants.dayMonthYearDisplay)
  static let yearMonthDayGMT0 = dateFormatter(format: Constants.yearMonthDayISO,
                                              timeZone: TimeZone(secondsFromGMT: 0))

  private static func dateFormatter(format: String, timeZone: TimeZone? = .current) -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = .current
    dateFormatter.timeZone = timeZone
    return dateFormatter
  }
}

extension DateFormatter {
  static func prettyStringDate(from startDateString: String, to endDateString: String) -> String {
    let startDate = DateFormatter.yearMonthDayISO.date(from: startDateString)
    let endDate = DateFormatter.yearMonthDayISO.date(from: endDateString)
    
    guard let startDate = startDate, let endDate = endDate else { return "" }
    
    let startDateCalendar = Calendar(identifier: .iso8601).dateComponents([.day, .month, .year], from: startDate)
    let endDateCalendar = Calendar(identifier: .iso8601).dateComponents([.day, .month, .year], from: endDate)

    let sameMonth = startDateCalendar.month == endDateCalendar.month
    let sameYear = startDateCalendar.year == endDateCalendar.year
    let startDateNeedYear = startDateCalendar.year != Calendar(identifier: .iso8601).dateComponents([.year], from: Date()).year
    && !sameMonth ? true : false

    let endDateNeedYear = endDateCalendar.year != Calendar(identifier: .iso8601).dateComponents([.year], from: Date()).year
    ? true : false
    let sameDate = startDate == endDate 

    var prettyFirstDate: String = ""
    var prettySecondDate: String = ""

    if let startDay = startDateCalendar.day, let endDay = endDateCalendar.day {
        prettyFirstDate = String(startDay)
        prettySecondDate = String(endDay)
    }

    if let month = endDateCalendar.month {
        prettySecondDate += " \(DateFormatter().monthSymbols[month - 1])"
    }

    if !sameMonth || !sameYear {
        if let month = startDateCalendar.month {
            prettyFirstDate += " \(DateFormatter().monthSymbols[month - 1])"
        }
    }

    if startDateNeedYear || !sameYear {
        if let year = startDateCalendar.year {
            prettyFirstDate += " \(String(year))"
        }
    }

    if endDateNeedYear || !sameYear {
        if let year = endDateCalendar.year {
            prettySecondDate += " \(String(year))"
        }
    }

    if sameDate {
        return prettySecondDate
    } else {
        return "\(prettyFirstDate) - \(prettySecondDate)"
    }
  }
}

