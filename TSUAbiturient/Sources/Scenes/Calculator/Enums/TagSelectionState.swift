//
//  TagSelectionState.swift
//  TSUAbiturient
//

import UIKit

enum TagSelectionState {
  case selected, unselected

  var backgroundColor: UIColor {
    switch self {
    case .selected:
      return .Light.Button.Primary.background
    case .unselected:
      return .Light.Surface.tertiary
    }
  }

  var textColor: UIColor {
    switch self {
    case .selected:
      return .Light.Text.white
    case .unselected:
      return .Light.Text.primary
    }
  }
}
