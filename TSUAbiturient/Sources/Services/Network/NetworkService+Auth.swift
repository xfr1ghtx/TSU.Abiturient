//
//  NetworkService+Auth.swift
//  TSUAbiturient
//

import Foundation

extension NetworkService: AuthNetworkProtocol {
  private struct Keys {
    static let token = "token"
  }
  
  func loginWithTSUAccount(token: String?) async throws -> AuthResponse {
    let parameters = [
      Keys.token: token ?? ""
    ]
    
    return try await request(method: .post,
                             url: URLFactory.Auth.loginTsuAccount,
                             parameters: parameters)
  }
  
  func updateSessionCredentials(with tokens: AuthCredentials?) {
    authenticationInterceptor.credential = tokens
  }
}
