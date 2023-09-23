//
//  FacultyLink.swift
//  TSUAbiturient
//

import Foundation

struct FacultyLink: Codable {
  enum FacultyLinkType: String, Codable {
      case abiturient = "ABITURIENT", other = "OTHER"
  }
  
  let id: Int
  let link: String
  let description: String
  let type: FacultyLinkType
}
