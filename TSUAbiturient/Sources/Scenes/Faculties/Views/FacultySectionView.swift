//
//  FacultySectionView.swift
//  TSUAbiturient
//

import UIKit

class FacultySectionView: UIView {
  // MARK: - Properties
  
  var title: String? {
    get {
      titleLabel.text
    }
    set {
      titleLabel.text = newValue
    }
  }
  
  private let titleLabel = Label(textStyle: .header3)
  private let containerView = UIView()
  
  // MARK: - Init
  
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Public methods
  
  func addContentView(_ contentView: UIView) {
    containerView.subviews.forEach { $0.removeFromSuperview() }
    containerView.addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupTitleLabel()
    setupContainerView()
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.numberOfLines = 0
    titleLabel.textColor = UIColor.Light.Text.primary
    titleLabel.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview().inset(16)
    }
  }
  
  private func setupContainerView() {
    addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().inset(16)
    }
  }
}
