//
//  DirectionDetailsCoordinator.swift
//  TSUAbiturient
//

import Foundation

struct DirectionDetailsCoordinatorConfiguration {
  let direction: EducationDirection
}

final class DirectionDetailsCoordinator: ConfigurableCoordinator {
  
  // MARK: - Properties

  typealias Configuration = DirectionDetailsCoordinatorConfiguration
  
  var navigationController: NavigationController
  
  var appDependency: AppDependency
  
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
  
  // MARK: - Navigation methods
  
  func start(animated: Bool) {
    showDirectionDetailsView()
  }
  
  private func showDirectionDetailsView() {
    let viewModel = DirectionDetailsViewModel(directionDetails: configuration.direction)
    let viewController = DirectionDetailsViewController(viewModel: viewModel)
    
    viewController.navigationItem.title = Localizable.Calculator.directionDetailsTitle
    
    navigationController.pushViewController(viewController, animated: true)
  }
}
