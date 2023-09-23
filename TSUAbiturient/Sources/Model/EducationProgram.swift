//
//  EducationProgram.swift
//  TSUAbiturient
//

import Foundation

enum EducationBase: String, Codable {
  case budget = "Budget", contract = "Contract", target = "Target"
  
  var name: String {
    switch self {
    case .budget:
      return Localizable.Enrollment.Program.budget
    case .contract:
      return Localizable.Enrollment.Program.contract
    case .target:
      return Localizable.Enrollment.Program.target
    }
  }
}
