//
//  NumberFormatter+CurrencyFormatter.swift
//  TSUAbiturient
//

import Foundation

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
  
  static func formatCurrency(_ value: Double, withDecimal: Bool) -> String {
      currencyFormatter.maximumFractionDigits = withDecimal ? 2 : 0
      return String((currencyFormatter.string(from: value as NSNumber) ?? "").dropLast())
  }
}
