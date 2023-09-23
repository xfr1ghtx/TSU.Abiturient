//
//  TagView.swift
//  TSUAbiturient
//

import UIKit

final class TagView: UIView {
  // MARK: - Properties
  
  private let titleLabel = Label(textStyle: .footnote)
  
  private let text: String
  
  // MARK: - Init
  
  init(withText text: String) {
    self.text = text
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("TagView init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupTitleLabel()
  }
  
  private func setupContainer() {
    layer.cornerRadius = 12
    layer.cornerCurve = .continuous
    layer.backgroundColor = UIColor.Light.Surface.tertiary.cgColor
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    
    titleLabel.textColor = .Light.Text.primary
    titleLabel.text = text
    
    titleLabel.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview().inset(4)
      make.horizontalEdges.equalToSuperview().inset(8)
    }
  }
}
