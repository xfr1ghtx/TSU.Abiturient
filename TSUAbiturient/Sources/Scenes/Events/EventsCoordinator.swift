//
//  EventsCoordinator.swift
//  TSUAbiturient
//

import Foundation
import UIKit

struct EventsCoordinatorConfiguration {
  let events: [Event]
}

final class EventsCoordinator: ConfigurableCoordinator {
  typealias Configuration = EventsCoordinatorConfiguration
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
    showEventsScreen(animated: animated)
  }
  
  private func showEventsScreen(animated: Bool) {
    let viewModel = EventsViewModel(with: configuration.events)
    viewModel.delegate = self
    let viewController = EventsViewController(viewModel: viewModel)
    viewController.title = Localizable.UpcommingEvents.EventsScreen.title
    viewController.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(viewController, animated: true)
  }
  
  private func showEventDetailScreen(with event: Event) {
    let configuration = EventDetailsCoordinatorConfiguration(event: event)
    show(EventDetailsCoordinator.self, configuration: configuration, animated: true)
  }
}

// MARK: - EventsViewModelDelegate

extension EventsCoordinator: EventsViewModelDelegate {
  func eventsViewModel(_ viewModel: EventsViewModel, didRequestToShow event: Event) {
    showEventDetailScreen(with: event)
  }
}
