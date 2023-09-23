//
//  DirectionsListSections.swift
//  TSUAbiturient
//

import Foundation

enum DirectionsListSections: Int, Hashable {
  case chooseSubjects = 0

  var sectionViewTitle: String {
    switch self {
    case .chooseSubjects:
      return Localizable.Calculator.tableTitle
    }
  }
}
