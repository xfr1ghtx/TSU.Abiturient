//
//  AuthResponse.swift
//  TSUAbiturient
//

import Foundation
import Alamofire

struct AuthResponse: Codable {
  let success: Bool
  let data: AuthCredentials
  let message: String
}

struct AuthCredentials: Codable, AuthenticationCredential {
  var requiresRefresh: Bool {
    guard let tokenExpirationTime = tokenExpirationTime else { return true }
    return Date(timeIntervalSinceNow: 60).timeIntervalSince1970 > tokenExpirationTime
  }
  
  var tokenExpirationTime: TimeInterval?
  let token: String
  let accountID: String
  
  enum CodingKeys: String, CodingKey {
    case tokenExpirationTime
    case token, accountID = "account_id"
  }
}
