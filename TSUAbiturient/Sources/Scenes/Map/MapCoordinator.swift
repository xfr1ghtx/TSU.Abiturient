//
//  MapCoordinator.swift
//  TSUAbiturient
//

import Foundation

final class MapCoordinator: Coordinator {
  // MARK: - Properties

  let navigationController: NavigationController
  let appDependency: AppDependency

  var childCoordinators: [Coordinator] = []
  var onDidFinish: (() -> Void)?

  // MARK: - Init

  required init(navigationController: NavigationController, appDependency: AppDependency) {
    self.navigationController = navigationController
    self.appDependency = appDependency
  }

  // MARK: - Navigation

  func start(animated: Bool) {
    showMapScreen(animated: animated)
  }

  private func showMapScreen(animated: Bool) {
    let viewModel = MapViewModel(dependencies: appDependency)
    let viewController = MapViewController(viewModel: viewModel)
    viewController.hidesBottomBarWhenPushed = true
    viewController.title = Localizable.Map.title
    addPopObserver(for: viewController)
    navigationController.pushViewController(viewController, animated: animated)
  }
}
