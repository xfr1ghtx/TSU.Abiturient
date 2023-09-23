//
//  Directions.swift
//  TSUAbiturient
//

import Foundation

struct Directions: Codable, Hashable {
  let programs: [EducationDirection?]
  let recommendPrograms: [EducationDirection?]
  
  enum CodingKeys: String, CodingKey {
    case programs, recommendPrograms = "recommended_programs"
  }
}
