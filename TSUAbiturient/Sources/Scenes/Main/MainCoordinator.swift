//
//  MainCoordinator.swift
//  TSUAbiturient
//

import Foundation

protocol MainCoordinatorDelegate: AnyObject {
  func mainCoordinator(_ coordinator: MainCoordinator, didRequestToShow news: News)
  func mainCoordinator(_ coordinator: MainCoordinator, didRequestToShow event: Event)
  func mainCoordinator(_ coordinator: MainCoordinator, didRequestToShow events: [Event])
}

final class MainCoordinator: Coordinator {
  // MARK: - Properties
  
  let navigationController: NavigationController
  let appDependency: AppDependency
  
  weak var delegate: MainCoordinatorDelegate?
  
  var childCoordinators: [Coordinator] = []
  var onDidFinish: (() -> Void)?
  
  // MARK: - Init
  
  init(navigationController: NavigationController, appDependency: AppDependency) {
    self.navigationController = navigationController
    self.appDependency = appDependency
  }
  
  // MARK: - Navigation
  
  func start(animated: Bool) {
    showMainScreen(animated: animated)
  }
  
  private func showMainScreen(animated: Bool) {
    let viewModel = MainViewModel(dependencies: appDependency)
    viewModel.delegate = self
    let viewController = MainViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: animated)
  }
  
  private func showAuth(animated: Bool) {
    show(AuthCoordinator.self, animated: animated)
  }
}

// MARK: - MainViewModelDelegate

extension MainCoordinator: MainViewModelDelegate {
  func mainViewModel(_ viewModel: MainViewModel, didRequestToShow news: News) {
    delegate?.mainCoordinator(self, didRequestToShow: news)
  }
  
  func mainViewModel(_ viewModel: MainViewModel, didRequestToShow event: Event) {
    delegate?.mainCoordinator(self, didRequestToShow: event)
  }
  
  func mainViewModel(_ viewModel: MainViewModel, didRequestToShow events: [Event]) {
    delegate?.mainCoordinator(self, didRequestToShow: events)
  }
  
  func mainViewModelDidRequestToShowAuth(_ viewModel: MainViewModel) {
    showAuth(animated: true)
  }
}
