//
//  TabBarCoordinator.swift
//  TSUAbiturient
//

import UIKit

final class TabBarCoordinator: Coordinator {
  // MARK: - Public Properties
  
  var childCoordinators: [Coordinator] = []
  var onDidFinish: (() -> Void)?
  
  var navigationController: NavigationController
  var appDependency: AppDependency
  
  // MARK: - Init
  
  init(navigationController: NavigationController, appDependency: AppDependency) {
    self.navigationController = navigationController
    self.appDependency = appDependency
  }
  
  // MARK: - Navigation
  
  func start(animated: Bool) {
    let tabBarController = setupTabBarController()
    navigationController.pushViewController(tabBarController, animated: true)
  }
  
  private func showNewsDetailsScreen(with news: News) {
    let configuration = NewsDetailsCoordinatorConfiguration(news: news)
    show(NewsDetailsCoordinator.self, configuration: configuration, animated: true)
  }
  
  private func showEventDetailScreen(with event: Event) {
    let configuration = EventDetailsCoordinatorConfiguration(event: event)
    show(EventDetailsCoordinator.self, configuration: configuration, animated: true)
  }
  
  private func showEventsScreen(with events: [Event]) {
    let configuration = EventsCoordinatorConfiguration(events: events)
    show(EventsCoordinator.self, configuration: configuration, animated: true)
  }
  
  // MARK: - Private methods
  
  private func setupTabBarController() -> TabBarController {
    let mainNavController = NavigationController()
    mainNavController.tabBarItem = UITabBarItem(title: TabBarTabItems.main.title,
                                                image: TabBarTabItems.main.icon,
                                                tag: 0)
    let mainCoordinator = MainCoordinator(navigationController: mainNavController, appDependency: appDependency)
    mainCoordinator.delegate = self
    childCoordinators.append(mainCoordinator)
    mainCoordinator.start(animated: false)
    
    let guideNavController = NavigationController()
    guideNavController.tabBarItem = UITabBarItem(title: TabBarTabItems.guide.title,
                                                 image: TabBarTabItems.guide.icon,
                                                 tag: 0)
    let guideCoordinator = GuideBookCoordinator(navigationController: guideNavController, appDependency: appDependency)
    childCoordinators.append(guideCoordinator)
    guideCoordinator.start(animated: false)
    
    let enrollmentNavController = NavigationController()
    enrollmentNavController.tabBarItem = UITabBarItem(title: TabBarTabItems.enrollment.title,
                                                      image: TabBarTabItems.enrollment.icon,
                                                      tag: 0)
    let enrollmentCoordinator = EnrollmentCoordinator(navigationController: enrollmentNavController, appDependency: appDependency)
    childCoordinators.append(enrollmentCoordinator)
    enrollmentCoordinator.start(animated: false)
    
    let tabBarController = TabBarController()
    tabBarController.viewControllers = [mainNavController, guideNavController, enrollmentNavController]
    
    return tabBarController
  }
}

// MARK: - MainCoordinatorDelegate

extension TabBarCoordinator: MainCoordinatorDelegate {
  func mainCoordinator(_ coordinator: MainCoordinator, didRequestToShow news: News) {
    showNewsDetailsScreen(with: news)
  }
  
  func mainCoordinator(_ coordinator: MainCoordinator, didRequestToShow event: Event) {
    showEventDetailScreen(with: event)
  }
  
  func mainCoordinator(_ coordinator: MainCoordinator, didRequestToShow events: [Event]) {
    showEventsScreen(with: events)
  }
}
