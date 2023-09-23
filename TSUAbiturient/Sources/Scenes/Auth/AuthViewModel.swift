//
//  AuthViewModel.swift
//  TSUAbiturient
//

import Foundation
import WebKit

protocol AuthViewModelDelegate: AnyObject {
  func authViewModelDidReceiveToken(_ authViewModel: AuthViewModel)
  func authViewModelDidFinish(_ authViewModel: AuthViewModel)
}

final class AuthViewModel: NSObject {
  typealias Dependencies = HasOAuthService

  // MARK: - Properties
  
  weak var delegate: AuthViewModelDelegate?
  
  private let dependencies: Dependencies
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public methods
  
  func initialLoadRedirectTo(URL: URL) -> WKNavigationActionPolicy {
    guard let URLComponents = URLComponents(url: URL, resolvingAgainstBaseURL: false) else { return .cancel }
    guard URLComponents.host == "lks.tsu.ru" || URLComponents.host == "accounts.tsu.ru" else { return .cancel }
    if URLComponents.path == "/tsu-account/login" {
      dependencies.oAuthService.loginWithTSUAccount(with: URL)
      delegate?.authViewModelDidReceiveToken(self)
      return .cancel
    }
    return .allow
  }
  
  func viewControllerDidFinish() {
    delegate?.authViewModelDidFinish(self)
  }
}
