//
//  FacultyLinkView.swift
//  TSUAbiturient
//

import UIKit

class FacultyLinkView: UIView {
  // MARK: - Properties
  
  var onDidTap: ((_ link: FacultyLink) -> Void)?
  
  private let titleLabel = Label(textStyle: .body)
  private let iconImageView = UIImageView()
  
  private var link: FacultyLink?
  
  // MARK: - Init
  
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Configure
  
  func configure(with link: FacultyLink) {
    self.link = link
    titleLabel.text = link.description
  }
  
  // MARK: - Actions
  
  @objc private func handleTap() {
    guard let link = link else { return }
    onDidTap?(link)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupContactLabel()
    setupIconImageView()
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  private func setupContainer() {
    backgroundColor = UIColor.Light.Surface.secondary
    layer.cornerRadius = 8
    layer.cornerCurve = .continuous
  }
  
  private func setupContactLabel() {
    addSubview(titleLabel)
    titleLabel.textColor = UIColor.Light.Text.primary
    titleLabel.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview().inset(16)
    }
  }
  
  private func setupIconImageView() {
    addSubview(iconImageView)
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.image = Assets.Images.externalLink.image
    iconImageView.snp.makeConstraints { make in
      make.size.equalTo(16)
      make.trailing.equalToSuperview().inset(16)
      make.centerY.equalTo(titleLabel)
      make.leading.equalTo(titleLabel.snp.trailing).offset(8)
    }
  }
}
