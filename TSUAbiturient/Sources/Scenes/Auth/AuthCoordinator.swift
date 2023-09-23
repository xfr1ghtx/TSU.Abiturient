//
//  AuthCoordinator.swift
//  TSUAbiturient
//

import Foundation
import SafariServices

final class AuthCoordinator: Coordinator {
  // MARK: - Properties
  
  let navigationController: NavigationController
  let appDependency: AppDependency
  
  var childCoordinators: [Coordinator] = []
  var onDidFinish: (() -> Void)?
  
  // MARK: - Init
  
  init(navigationController: NavigationController, appDependency: AppDependency) {
    self.navigationController = navigationController
    self.appDependency = appDependency
  }
  
  // MARK: - Actions
  
  @objc
  private func closeWebView() {
    navigationController.dismiss(animated: true)
    onDidFinish?()
  }
  
  // MARK: - Navigation
  
  func start(animated: Bool) {
    showAuthWebView(animated: animated)
  }
  
  func showAuthWebView(animated: Bool) {
    guard let authPageURL = appDependency.oAuthService.authPageURL else { return }
    
    let viewModel = AuthViewModel(dependencies: appDependency)
    viewModel.delegate = self
    
    let modalNavigationController = NavigationController()
    
    let viewController = AuthViewController(viewModel: viewModel, authPageURL: authPageURL)
    
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localizable.Common.cancel,
                                                                       style: .plain, target: self,
                                                                       action: #selector(closeWebView))
    
    modalNavigationController.pushViewController(viewController, animated: false)
    navigationController.present(modalNavigationController, animated: animated)
  }
}

// MARK: - AuthViewModelDelegate

extension AuthCoordinator: AuthViewModelDelegate {
  func authViewModelDidReceiveToken(_ authViewModel: AuthViewModel) {
    navigationController.dismiss(animated: true)
    onDidFinish?()
  }
  
  func authViewModelDidFinish(_ authViewModel: AuthViewModel) {
    onDidFinish?()
  }
}
