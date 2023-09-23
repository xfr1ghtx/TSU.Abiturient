//
//  AppCoordinator.swift
//  TSUAbiturient
//

import UIKit

final class AppCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var onDidFinish: (() -> Void)?
  
  let navigationController: NavigationController
  let appDependency: AppDependency
  
  private let utility: AppCoordinatorUtility
  
  required init(navigationController: NavigationController,
                appDependency: AppDependency = AppDependency()) {
    self.navigationController = navigationController
    self.appDependency = appDependency
    self.utility = AppCoordinatorUtility(appDependency: appDependency)
  }
  
  func start(animated: Bool) {
    utility.start()
    show(TabBarCoordinator.self, animated: animated)
  }
  
  private func resetCoordinators() {
    navigationController.dismiss(animated: false, completion: nil)
    navigationController.setViewControllers([], animated: false)
    navigationController.removeAllPopObservers()
    childCoordinators.removeAll()
    if let window = UIApplication.shared.connectedScenes
      .filter({ $0.activationState == .foregroundActive })
      .map({ $0 as? UIWindowScene })
      .compactMap({ $0 })
      .first?.windows
      .first(where: { $0.isKeyWindow }) {
      changeRootViewController(of: window, to: navigationController)
    }
    start(animated: false)
  }
  
  private func changeRootViewController(of window: UIWindow,
                                        to viewController: UIViewController,
                                        animationDuration: TimeInterval = 0.5) {
    let animations = {
      UIView.performWithoutAnimation {
        window.rootViewController = self.navigationController
      }
    }
    UIView.transition(with: window, duration: animationDuration, options: .transitionFlipFromLeft,
                      animations: animations, completion: nil)
  }
}
