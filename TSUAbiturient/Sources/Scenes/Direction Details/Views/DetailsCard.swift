//
//  DetailsCard.swift
//  TSUAbiturient
//

import UIKit

final class DetailsCard: UIView {
  // MARK: - Properties
  
  private let titleLabel = Label(textStyle: .body)
  private let countLabel = Label(textStyle: .header2)
  
  // MARK: - Init
  
  init(titleText: String, countText: String) {
    titleLabel.text = titleText
    countLabel.text = countText
    super.init(frame: .zero)
    setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupView()
    setupDateLabel()
    setupNameLabel()
  }
  
  private func setupView() {
    layer.backgroundColor = UIColor.Light.Surface.secondary.cgColor
    layer.cornerRadius = 16
    layer.cornerCurve = .continuous
  }
  
  private func setupDateLabel() {
    addSubview(titleLabel)
    titleLabel.numberOfLines = 1
    titleLabel.textColor = .Light.Text.accent
    titleLabel.snp.makeConstraints { make in
      make.horizontalEdges.top.equalToSuperview().inset(16)
    }
  }
  
  private func setupNameLabel() {
    addSubview(countLabel)
    countLabel.textColor = .Light.Text.primary
    countLabel.adjustsFontSizeToFitWidth = false
    countLabel.lineBreakMode = .byTruncatingTail
    countLabel.bottomAlignment = true
    countLabel.snp.makeConstraints { make in
      make.horizontalEdges.bottom.equalToSuperview().inset(16)
      make.top.equalTo(titleLabel.snp.bottom).offset(4)
      make.height.equalTo(32)
    }
  }
}
