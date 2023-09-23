//
//  GradientBackgroundView.swift
//  TSUAbiturient
//

import UIKit

final class GradientBackgroundView: UIView {
  // MARK: - Properties
  
  private lazy var firstGradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.Gradient.blue.cgColor, UIColor.Gradient.turquoise.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    
    return gradientLayer
  }()
  
  private lazy var secondGradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.Gradient.whiteTransparent.cgColor, UIColor.Gradient.white.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    
    return gradientLayer
  }()
  
  // MARK: - Inits
  
  init() {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  // MARK: - Override
  
  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    firstGradientLayer.frame = self.bounds
    self.layer.insertSublayer(firstGradientLayer, at: 0)
    
    secondGradientLayer.frame = self.bounds
    self.layer.insertSublayer(secondGradientLayer, above: firstGradientLayer)
    self.clipsToBounds = true
  }
}
