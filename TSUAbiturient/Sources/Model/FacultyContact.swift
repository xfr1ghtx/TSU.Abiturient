//
//  FacultyContact.swift
//  TSUAbiturient
//

import Foundation

struct FacultyContact: Codable {
  enum FacultyContactType: String, Codable {
    case phone = "PHONE", email = "EMAIL"
  }
  
  let id: Int
  let contact: String
  let description: String
  let type: FacultyContactType
}
