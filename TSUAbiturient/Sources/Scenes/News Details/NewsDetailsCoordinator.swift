//
//  NewsDetailsCoordinator.swift
//  TSUAbiturient
//

import Foundation

struct NewsDetailsCoordinatorConfiguration {
  let news: News
}

final class NewsDetailsCoordinator: ConfigurableCoordinator {
  typealias Configuration = NewsDetailsCoordinatorConfiguration
  
  // MARK: - Properties
  
  let navigationController: NavigationController
  let appDependency: AppDependency
  
  var childCoordinators: [Coordinator] = []
  var onDidFinish: (() -> Void)?
  
  private let configuration: Configuration
  
  // MARK: - Init
  
  init(navigationController: NavigationController,
       appDependency: AppDependency,
       configuration: NewsDetailsCoordinatorConfiguration) {
    self.navigationController = navigationController
    self.appDependency = appDependency
    self.configuration = configuration
  }
  
  // MARK: - Navigation
  
  func start(animated: Bool) {
    showNewsDetailsScreen(animated: true)
  }
  
  private func showNewsDetailsScreen(animated: Bool) {
    let viewModel = NewsDetailsViewModel(news: configuration.news, dependencies: appDependency)
    let viewController = NewsDetailsViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}
