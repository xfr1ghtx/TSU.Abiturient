//
//  AnimationCurve+Option.swift
//  TSUAbiturient
//

import UIKit

extension UIView.AnimationCurve {
  var option: UIView.AnimationOptions {
    switch self {
    case .linear:
      return .curveLinear
    case .easeIn:
      return .curveEaseIn
    case .easeOut:
      return .curveEaseOut
    case .easeInOut:
      return .curveEaseInOut
    @unknown default:
      return .curveLinear
    }
  }
}
