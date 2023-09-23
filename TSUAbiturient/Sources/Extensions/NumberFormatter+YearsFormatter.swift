//
//  NumberFormatter+YearsFormatter.swift
//  TSUAbiturient
//

import Foundation

extension NumberFormatter {
  static func formatYear(_ value: String) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2

    let years = value

    let formattedYears = formatter.number(from: years)
    guard let currentFormattedYears = formattedYears else { return "" }
    let yearsString = Localizable.Plurals.formattedYears(currentFormattedYears, Float(years) ?? 0.0)

    return yearsString
  }
}
