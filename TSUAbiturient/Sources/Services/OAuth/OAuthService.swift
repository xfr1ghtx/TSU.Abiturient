//
//  OAuthService.swift
//  TSUAbiturient
//

import Foundation

protocol OAuthServiceProtocol: AnyObject {
  var authPageURL: URL? { get }
  var isAuthorized: Bool { get }

  func loginWithTSUAccount(with linkURL: URL)
  func logoutFromTSUAccount()
  func updateSessionCredentialsFromKeychain()
}

final class OAuthService: OAuthServiceProtocol, BannerShowing {
  // MARK: - Keys
  
  private enum Keys: String {
    case token
  }
  
  // MARK: - Properties
  
  var authPageURL: URL? {
    URL(string: URLFactory.Auth.oAuthPage)
  }
  
  var isAuthorized: Bool {
    keyChainService.hasData(service: .token, account: .tsuAccount)
  }
  
  private let authService: AuthNetworkProtocol
  private let userService: UserNetworkProtocol
  private let keyChainService: KeyChainServiceProtocol
  private let dataStoreService: DataStoreProtocol
  
  // MARK: - Init
  
  init(authNetworkProtocol: AuthNetworkProtocol,
       userNetworkProtocol: UserNetworkProtocol,
       keyChainService: KeyChainServiceProtocol,
       dataStoreService: DataStoreProtocol) {
    self.authService = authNetworkProtocol
    self.userService = userNetworkProtocol
    self.keyChainService = keyChainService
    self.dataStoreService = dataStoreService
    
    let token: AuthCredentials? = keyChainService.read(service: .token, account: .tsuAccount)
    authService.updateSessionCredentials(with: token)
  }
  
  func loginWithTSUAccount(with linkURL: URL) {
    let token = getToken(from: linkURL)
    Task {
      do {
        let authResponse = try await authService.loginWithTSUAccount(token: token)
        await MainActor.run {
          handle(authResponse: authResponse)
        }
      } catch let error {
        await MainActor.run {
          handle(error: error)
        }
      }
    }
  }
  
  func logoutFromTSUAccount() {
    keyChainService.delete(service: .token, account: .tsuAccount)
    dataStoreService.clearAllData()
  }
  
  func updateSessionCredentialsFromKeychain() {
    let token: AuthCredentials? = keyChainService.read(service: .token, account: .tsuAccount)
    authService.updateSessionCredentials(with: token)
  }
  
  // MARK: - Private methods
  
  private func handle(error: Error) {
    showBanner(title: nil, subtitle: error.localizedDescription, style: .danger)
    logoutFromTSUAccount()
  }
  
  private func handle(authResponse: AuthResponse) {
    update(token: authResponse.data)
    loadProfile(accountID: authResponse.data.accountID)
  }
  
  private func loadProfile(accountID: String) {
    Task {
      do {
        let profile = try await userService.getUserProfileFromLKA(accountID: accountID)
        await MainActor.run {
          save(LKAProfile: profile.data)
        }
      } catch {
        let profile = try await userService.getUserProfileFromLKS()
        await MainActor.run {
          save(LKSProfile: profile.data)
        }
      }
    }
  }
  
  private func save(LKAProfile profile: UserProfileLKA) {
    let userProfile = UserProfile(tsuAccountID: profile.TSUAccountID,
                                  firstName: profile.firstName,
                                  lastName: profile.lastName,
                                  patronymic: profile.patronymic,
                                  requestID: profile.request.id)
    dataStoreService.userProfile = userProfile
  }
  
  private func save(LKSProfile profile: UserProfileLKS) {
    let userProfile = UserProfile(tsuAccountID: profile.accountID,
                                  firstName: profile.firstName,
                                  lastName: profile.lastName,
                                  patronymic: profile.secondName)
    dataStoreService.userProfile = userProfile
  }
  
  private func update(token: AuthCredentials) {
    var copyToken = token
    copyToken.tokenExpirationTime = Date().timeIntervalSince1970 + TimeInterval(2505600)
    keyChainService.save(copyToken, service: .token, account: .tsuAccount)
    authService.updateSessionCredentials(with: copyToken)
  }
  
  private func getToken(from url: URL) -> String? {
    guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
    let item = urlComponents.queryItems?.first { $0.name == Keys.token.rawValue }
    return item?.value
  }
  
}

extension OAuthService: OAuthAuthenticatorDelegate {
  func oAuthAuthenticatorDidRequestRefresh(_ oAuthAuthenticator: OAuthAuthenticator,
                                           with credential: AuthCredentials,
                                           completion: @escaping (Result<AuthCredentials, Error>) -> Void) {
    Task {
      await MainActor.run {
        logoutFromTSUAccount()
      }
    }
  }
}
