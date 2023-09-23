//
//  PositionView.swift
//  TSUAbiturient
//


import UIKit

final class SecondaryPositionView: UIView {
  // MARK: - Properties
  
  private let label = Label(textStyle: .bodyBold)
  private let priority: Int
  private let color: UIColor
  private let labelWidth: CGFloat
  
  // MARK: - Init
  
  init(with priority: Int, color: UIColor, labelWidth: CGFloat) {
    self.labelWidth = labelWidth
    self.priority = priority
    self.color = color
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("PositionView init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setup() {
    layer.cornerRadius = 4
    layer.cornerCurve = .continuous
    layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    backgroundColor = color
    
    addSubview(label)
    
    if color == .Light.Surface.tertiary {
      label.textColor = .Light.Text.primary
    } else {
      label.textColor = .Light.Text.white
    }
    label.text = "\(priority)"
    label.textAlignment = .center
    
    label.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(8)
      make.top.bottom.equalToSuperview().inset(4)
      make.width.equalTo(labelWidth - 4)
    }
  }
}

final class PrimaryPositionView: UIView {
  // MARK: - Properties
  
  private let label = Label(textStyle: .header3)
  private let squareView = UIView()
  private let triangle = UIImageView(image: Assets.Images.badgeTriangle.image.withRenderingMode(.alwaysTemplate))
  private let priority: Int
  private let color: UIColor
  private let labelWidth: CGFloat
  
  // MARK: - Init
  
  init(with priority: Int, color: UIColor, labelWidth: CGFloat) {
    self.labelWidth = labelWidth
    self.priority = priority
    self.color = color
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("PositionView init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setup() {
    squareView.backgroundColor = color
    triangle.tintColor = color
    triangle.contentMode = .scaleAspectFill
    
    addSubview(squareView)
    squareView.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview()
    }
    addSubview(triangle)
    triangle.snp.makeConstraints { make in
      make.top.bottom.trailing.equalToSuperview()
      make.leading.equalTo(squareView.snp.trailing)
      make.width.equalTo(8)
    }
    addSubview(label)
  
    if color == .Light.Surface.tertiary {
      label.textColor = .Light.Text.primary
    } else {
      label.textColor = .Light.Text.white
    }
    label.text = "\(priority)"
    label.textAlignment = .center
    
    label.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(8)
      make.trailing.equalToSuperview().inset(12)
      make.top.bottom.equalToSuperview().inset(4)
      make.width.equalTo(labelWidth)
    }
  }
}
