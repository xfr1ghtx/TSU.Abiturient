//
//  EducationFormListSections.swift
//  TSUAbiturient
//

import Foundation

enum EducationFormListSections: Int, Hashable, CaseIterable {
  case fullTime = 0, distantForm = 1, partTime = 2

  var educationFormTitle: String {
    switch self {
    case .fullTime:
      return Localizable.Calculator.fullTimeForm
    case .distantForm:
      return Localizable.Calculator.distantForm
    case .partTime:
      return Localizable.Calculator.partTimeForm
    }
  }
}
