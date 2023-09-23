//
//  FacultiesCoordinator.swift
//  TSUAbiturient
//

import UIKit

class FacultiesCoordinator: NSObject, Coordinator {
  // MARK: - Properties
  
  let navigationController: NavigationController
  let appDependency: AppDependency
  
  var childCoordinators: [Coordinator] = []
  var onDidFinish: (() -> Void)?
  
  private var onDidUpdateSearch: ((_ searchText: String?) -> Void)?
  
  // MARK: - Init
  
  required init(navigationController: NavigationController, appDependency: AppDependency) {
    self.navigationController = navigationController
    self.appDependency = appDependency
  }
  
  // MARK: - Navigation
  
  func start(animated: Bool) {
    showFaculties(animated: animated)
  }
  
  private func showFaculties(animated: Bool) {
    let viewModel = FacultiesViewModel(dependencies: appDependency)
    viewModel.delegate = self
    
    let viewController = FacultiesViewController(viewModel: viewModel)
    
    let searchController = UISearchController()
    searchController.searchResultsUpdater = self
    viewController.navigationItem.searchController = searchController
    onDidUpdateSearch = { [weak viewModel] searchText in
      viewModel?.updateSearch(with: searchText)
    }
    
    viewController.title = Localizable.Faculties.screenTitle
    viewController.hidesBottomBarWhenPushed = true
    viewController.navigationItem.hidesSearchBarWhenScrolling = false
    navigationController.pushViewController(viewController, animated: animated)
  }
  
  private func showFacultyDetails(faculty: Faculty) {
    let viewModel = FacultyDetailsViewModel(facultyID: faculty.id, dependencies: appDependency)
    let viewController = FacultyDetailsViewController(viewModel: viewModel)
    navigationController.present(viewController, animated: true)
  }
}

// MARK: - UISearchResultsUpdating

extension FacultiesCoordinator: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    onDidUpdateSearch?(searchController.searchBar.text)
  }
}

// MARK: - FacultiesViewModelDelegate

extension FacultiesCoordinator: FacultiesViewModelDelegate {
  func facultiesViewModel(_ viewModel: FacultiesViewModel, didSelect faculty: Faculty) {
    showFacultyDetails(faculty: faculty)
  }
}
