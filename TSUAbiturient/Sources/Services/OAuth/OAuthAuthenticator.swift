//
//  OAuthAuthenticator.swift
//  TSUAbiturient
//

import Foundation
import Alamofire

protocol OAuthAuthenticatorDelegate: AnyObject {
  func oAuthAuthenticatorDidRequestRefresh(_ oAuthAuthenticator: OAuthAuthenticator,
                                           with credential: AuthCredentials,
                                           completion: @escaping (Result<AuthCredentials, Error>) -> Void)
}

final class OAuthAuthenticator: Authenticator {
  weak var delegate: OAuthAuthenticatorDelegate?
  
  func apply(_ credential: AuthCredentials,
             to urlRequest: inout URLRequest) {
    urlRequest.headers.add(.authorization(bearerToken: credential.token))
  }
  
  func refresh(_ credential: AuthCredentials,
               for session: Session,
               completion: @escaping (Result<AuthCredentials, Error>) -> Void) {
    delegate?.oAuthAuthenticatorDidRequestRefresh(self, with: credential, completion: completion)
  }
  
  func didRequest(_ urlRequest: URLRequest,
                  with response: HTTPURLResponse,
                  failDueToAuthenticationError error: Error) -> Bool {
    response.statusCode == HTTPStatusCode.unauthorized.rawValue
  }
  
  func isRequest(_ urlRequest: URLRequest,
                 authenticatedWith credential: AuthCredentials) -> Bool {
    let credentialToken = HTTPHeader.authorization(bearerToken: credential.token).value
    let requestToken = urlRequest.value(forHTTPHeaderField: "Authorization")
    return requestToken == credentialToken
  }
}
