//
//  UIView+Shadow.swift
//  TSUAbiturient
//

import UIKit

extension UIView {
  func addShadow(offset: CGSize,
                 radius: CGFloat,
                 color: UIColor = .Light.Global.black.withAlphaComponent(0.15),
                 opacity: Float = 1) {
    layer.shadowOffset = offset
    layer.shadowRadius = radius
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
  }
}
