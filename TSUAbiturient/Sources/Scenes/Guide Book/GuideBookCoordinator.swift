//
//  GuideBookCoordinator.swift
//  TSUAbiturient
//

import Foundation

final class GuideBookCoordinator: Coordinator {
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
    showGuideBookScreen(animated: animated)
  }
  
  private func showGuideBookScreen(animated: Bool) {
    let viewModel = GuideBookViewModel(dependencies: appDependency)
    viewModel.delegate = self
    let viewController = GuideBookViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: animated)
  }
  
  private func showFacultiesScreen() {
    show(FacultiesCoordinator.self, animated: true)
    
  }
  
  private func showCalculatorScreen() {
    show(CalculatorCoordinator.self, animated: true)
  }
  
  private func showMapScreen() {
    show(MapCoordinator.self, animated: true)
  }
}

// MARK: - GuideBookViewModelDelegate

extension GuideBookCoordinator: GuideBookViewModelDelegate {
  func guideBookViewModelDidRequestToShowFaculties() {
    showFacultiesScreen()
  }
  
  func guideBookViewModelDidRequestToShowCalculator() {
    showCalculatorScreen()
  }
  
  func guideBookViewModelDidRequestToShowMap() {
    showMapScreen()
  }
  
  
}
