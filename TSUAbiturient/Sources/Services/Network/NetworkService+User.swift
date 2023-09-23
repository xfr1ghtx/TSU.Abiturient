//
//  NetworkService+User.swift
//  TSUAbiturient
//

import Foundation

extension NetworkService: UserNetworkProtocol {
  func getUserProfileFromLKS() async throws -> UserProfileLKSResponse {
    return try await request(method: .get, url: URLFactory.User.userProfileLKS, authorized: true)
  }
  
  func getUserProfileFromLKA(accountID: String) async throws -> UserProfileLKAResponse {
    return try await request(method: .get, url: URLFactory.User.userProfileLKA(accountID: accountID), authorized: true)
  }
}
