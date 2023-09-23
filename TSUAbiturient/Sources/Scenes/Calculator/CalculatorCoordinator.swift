//
//  CalculatorCoordinator.swift
//  TSUAbiturient
//

import UIKit

final class CalculatorCoordinator: Coordinator {
  // MARK: - Properties
  
  var navigationController: NavigationController
  var appDependency: AppDependency
  
  var childCoordinators: [Coordinator] = []
  var onDidFinish: (() -> Void)?
  
  private var transferSubjectsData: (([DisciplineTableCellViewModel]) -> Void)?
  private var updateSubjectsDataClosure: (([DisciplineTableCellViewModel]) -> Void)?
  private var subjectsData: [DisciplineTableCellViewModel] = []
  
  // MARK: - Init
  
  init(navigationController: NavigationController, appDependency: AppDependency) {
    self.navigationController = navigationController
    self.appDependency = appDependency
  }
  
  // MARK: - Navigation methods
  
  func start(animated: Bool) {
    showCalculatorScreen(animated: animated)
  }
  
  private func showCalculatorScreen(animated: Bool) {
    let viewModel = CalculatorViewModel(dependencies: appDependency)
    let viewController = CalculatorViewController(viewModel: viewModel)
    
    viewModel.delegate = self
    
    viewController.hidesBottomBarWhenPushed = true
    viewController.navigationItem.title = Localizable.Calculator.title
    
    transferSubjectsData = { data in
      viewModel.loadCurrentDirectionsWithSubjectData(data: data)
    }

    navigationController.pushViewController(viewController, animated: animated)
  }
  
  private func showDirectionsSelectionScreen() {
    showDirectionsSelectionScreen(animated: true)
  }

  private func showDirectionsSelectionScreen(animated: Bool) {
    let modalNavigationController = NavigationController()
    
    let viewModel = DirectionsSelectionViewModel(dependencies: appDependency)
    let viewController = DirectionsSelectionViewController(viewModel: viewModel)
    
    viewModel.delegate = self
    
    viewController.title = Localizable.Calculator.chooseDirections
    
    updateSubjectsDataClosure = { [weak self] data in
      self?.subjectsData = data
    }
    
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localizable.Common.close,
                                                                       style: .plain, target: self,
                                                                       action: #selector(closeDirectionsSelectionScreen))
    
    modalNavigationController.pushViewController(viewController, animated: animated)
    navigationController.present(modalNavigationController, animated: animated)
  }
  
  @objc private func closeDirectionsSelectionScreen() {
    navigationController.dismiss(animated: true)
  }
  
  private func showDetailsDirection(direction: EducationDirection) {
    let configuration = DirectionDetailsCoordinatorConfiguration(direction: direction)
    show(DirectionDetailsCoordinator.self, configuration: configuration, animated: true)
  }
}

extension CalculatorCoordinator: CalculatorViewModelDelegate {
  func directionDescriptionViewModel(_ viewModel: CalculatorViewModel, didRequestToShow direction: EducationDirection) {
    showDetailsDirection(direction: direction)
  }
  
  func transferSubjectsDataInView(data: [DisciplineTableCellViewModel]) {
    updateSubjectsDataClosure?(data)
  }
  
  func showSelectionsScreen() {
    showDirectionsSelectionScreen()
  }
}

extension CalculatorCoordinator: DirectionsSelectionViewModelDelegate {
  func getViewModelsData() -> [DisciplineTableCellViewModel] {
    return subjectsData
  }
  
  func transferViewModelData(_ data: [DisciplineTableCellViewModel]) {
    transferSubjectsData?(data)
  }
}
