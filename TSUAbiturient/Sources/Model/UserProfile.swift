//
//  UserProfile.swift
//  TSUAbiturient
//

import Foundation

struct UserProfile: Codable {
  let tsuAccountID: String
  let firstName: String
  let lastName: String
  let patronymic: String
  
  var requestID: String?
  
  enum CodingKeys: String, CodingKey {
    case firstName, lastName, patronymic
    case tsuAccountID = "tsuAccountId", requestID = "id"
  }
}
