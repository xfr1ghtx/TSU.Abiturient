//
//  EnrollmentCoordinator.swift
//  TSUAbiturient
//

import Foundation

final class EnrollmentCoordinator: Coordinator {
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
  
  // MARK: - Navigation
  
  func start(animated: Bool) {
    showEnrollmentScreen(animated: animated)
  }
  
  private func showEnrollmentScreen(animated: Bool) {
    let viewModel = EnrollmentViewModel(dependencies: appDependency)
    viewModel.delegate = self
    let viewController = EnrollmentViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: animated)
  }
}

// MARK: - EnrollmentViewModelDelegate

extension EnrollmentCoordinator: EnrollmentViewModelDelegate {
  func enrollmentViewModelDidRequestToShowAuth() {
    show(AuthCoordinator.self, animated: true)
  }
}
