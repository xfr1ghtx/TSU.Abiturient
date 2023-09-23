//
//  PriorityProgramsResponse.swift
//  TSUAbiturient
//

import UIKit

struct PriorityProgramsResponse: Codable {
  let data: [RatingProgram]
}

struct RatingProgram: Codable {
  let budgetType: BudgetType
  let curriculumID: String
  let place: Int?
  let color: RatingColor?
  
  enum CodingKeys: String, CodingKey {
    case budgetType, place, color
    case curriculumID = "curriculumId"
  }
}

enum BudgetType: String, Codable {
  case budget = "Budget"
  case contract = "Contract"
  case target = "Target"
  
  var priorityForSort: Int {
    switch self {
    case .budget:
      return 1
    case .contract:
      return 3
    case .target:
      return 2
    }
  }
}

enum RatingColor: String, Codable {
  case white = "White"
  case green = "Green"
  case yellow = "Yellow"
  case red = "Red"
  case blue = "Blue"
  
  var color: UIColor {
    switch self {
    case .white:
      return .Light.Surface.tertiary
    case .green:
      return .Light.Surface.accentGreen
    case .yellow:
      return .Light.Surface.accentYellow
    case .red:
      return .Light.Surface.accentRed
    case .blue:
      return .Light.Surface.accent
    }
  }
}
