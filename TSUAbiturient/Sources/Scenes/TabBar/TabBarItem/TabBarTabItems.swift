//
//  TabBarTabItems.swift
//  TSUAbiturient
//

import UIKit

enum TabBarTabItems: CaseIterable, TabBarItem {
  case main
  case guide
  case enrollment
  
  var icon: UIImage {
    switch self {
    case .main:
      return Assets.Images.flame.image
    case .guide:
      return Assets.Images.compass.image
    case .enrollment:
      return Assets.Images.rocket.image
    }
  }
  
  var title: String {
    switch self {
    case .main:
      return Localizable.TabBar.Tabs.Title.main
    case .guide:
      return Localizable.TabBar.Tabs.Title.guide
    case .enrollment:
      return Localizable.TabBar.Tabs.Title.enrollment
    }
  }
  
  static let selectedColor: UIColor = .Light.Icons.accent
  static let unselectedColor: UIColor = .Light.Icons.tertiary
}
