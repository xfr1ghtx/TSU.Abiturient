//
//  EducationDirection.swift
//  TSUAbiturient
//

import Foundation

struct EducationDirection: Codable, Hashable {
  let faculty: String
  let name: String
  let description: String
  let direction: String
  let directionGUID: String
  let profile: String
  let reqDisciplines: String
  let optDisciplines: String
  let score: Int
  let level: String
  let educationForm: String
  let period: String
  let cost: String
  let budgetCount: Int
  let paidCount: Int
}
