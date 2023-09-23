//
//  TabBarController.swift
//  TSUAbiturient
//

import UIKit

final class TabBarController: UITabBarController, NavigationBarHiding {
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    tabBar.tintColor = UIColor.Light.Icons.accent
    tabBar.unselectedItemTintColor = UIColor.Light.Icons.tertiary
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}
