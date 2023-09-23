//
//  UserProfileLKSResponse.swift
//  TSUAbiturient
//

import Foundation

struct UserProfileLKSResponse: Codable {
  let success: Bool
  let data: UserProfileLKS
  let message: String
}

struct UserProfileLKS: Codable {
  let firstName: String
  let secondName: String
  let lastName: String
  let accountID: String
  
  enum CodingKeys: String, CodingKey {
    case firstName = "first_name"
    case secondName = "second_name"
    case lastName = "last_name"
    case accountID = "account_id"
  }
}
