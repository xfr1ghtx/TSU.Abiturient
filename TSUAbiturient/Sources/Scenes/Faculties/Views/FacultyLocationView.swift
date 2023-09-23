//
//  FacultyLocationView.swift
//  TSUAbiturient
//

import UIKit

class FacultyLocationView: UIView {
  // MARK: - Properties
  
  var onDidTap: ((_ building: Building) -> Void)?
  
  private let contentStackView = UIStackView()
  private let captionStackView = UIStackView()
  private let captionIconImageView = UIImageView()
  private let captionLabel = Label(textStyle: .footnote)
  private let titleLabel = Label(textStyle: .body)
  private let addressLabel = Label(textStyle: .footnote)
  private let arrowImageView = UIImageView()
  
  private var building: Building?
  
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
  
  func configure(with building: Building) {
    self.building = building
    captionLabel.text = building.typeTitle
    captionIconImageView.image = building.typeImage
    titleLabel.text = building.name
    addressLabel.text = building.address
  }
  
  // MARK: - Actions
  
  @objc private func handleTap() {
    guard let building = building else { return }
    onDidTap?(building)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupContentStackView()
    setupCaptionStackView()
    setupCaptionIconImageView()
    setupCaptionLabel()
    setupTitleLabel()
    setupAddressLabel()
    setupArrowImageView()
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  private func setupContainer() {
    backgroundColor = UIColor.Light.Surface.secondary
    layer.cornerRadius = 8
    layer.cornerCurve = .continuous
  }
  
  private func setupContentStackView() {
    addSubview(contentStackView)
    contentStackView.axis = .vertical
    contentStackView.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview().inset(16)
    }
  }
  
  private func setupCaptionStackView() {
    contentStackView.addArrangedSubview(captionStackView)
    contentStackView.setCustomSpacing(8, after: captionStackView)
    captionStackView.axis = .horizontal
    captionStackView.spacing = 4
  }
  
  private func setupCaptionIconImageView() {
    captionStackView.addArrangedSubview(captionIconImageView)
    captionIconImageView.contentMode = .scaleAspectFit
    captionIconImageView.snp.makeConstraints { make in
      make.size.equalTo(16)
    }
  }
  
  private func setupCaptionLabel() {
    captionStackView.addArrangedSubview(captionLabel)
    captionLabel.textColor = UIColor.Light.Text.accent
  }
  
  private func setupTitleLabel() {
    contentStackView.addArrangedSubview(titleLabel)
    contentStackView.setCustomSpacing(4, after: titleLabel)
    titleLabel.textColor = UIColor.Light.Text.primary
  }
  
  private func setupAddressLabel() {
    contentStackView.addArrangedSubview(addressLabel)
    addressLabel.textColor = UIColor.Light.Text.primary
  }
  
  private func setupArrowImageView() {
    addSubview(arrowImageView)
    arrowImageView.image = Assets.Images.chevronRight.image
    arrowImageView.contentMode = .scaleAspectFit
    arrowImageView.snp.makeConstraints { make in
      make.size.equalTo(16)
      make.centerY.equalToSuperview()
      make.leading.equalTo(contentStackView.snp.trailing).offset(8)
      make.trailing.equalToSuperview().inset(16)
    }
  }
}
