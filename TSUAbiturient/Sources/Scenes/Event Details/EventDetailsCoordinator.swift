//
//  EventDetailsCoordinator.swift
//  TSUAbiturient
//

import Foundation

struct EventDetailsCoordinatorConfiguration {
  let event: Event
}

final class EventDetailsCoordinator: ConfigurableCoordinator {
  typealias Configuration = EventDetailsCoordinatorConfiguration
  
  // MARK: - Properties
  
  let navigationController: NavigationController
  let appDependency: AppDependency
  
  var childCoordinators: [Coordinator] = []
  var onDidFinish: (() -> Void)?
  
  private let configuration: Configuration
  
  // MARK: - Init
  
  init(navigationController: NavigationController,
       appDependency: AppDependency,
       configuration: Configuration) {
    self.navigationController = navigationController
    self.appDependency = appDependency
    self.configuration = configuration
  }
  
  // MARK: - Navigation
  
  func start(animated: Bool) {
    showEventDetailsScreen(animated: true)
  }
  
  private func showEventDetailsScreen(animated: Bool) {
    let viewModel = EventDetailsViewModel(event: configuration.event)
    let viewController = EventDetailsViewController(viewModel: viewModel)
    viewController.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(viewController, animated: true)
  }
}
