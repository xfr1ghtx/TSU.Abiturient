//
//  FacultyContactView.swift
//  TSUAbiturient
//

import UIKit

class FacultyContactView: UIView {
  // MARK: - Properties
  
  var onDidTap: ((_ contact: FacultyContact) -> Void)?
  
  private let contactLabel = Label(textStyle: .bodyBold)
  private let iconImageView = UIImageView()
  private let descriptionLabel = Label(textStyle: .footnote)
  
  private var contact: FacultyContact?
  
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
  
  func configure(with contact: FacultyContact) {
    self.contact = contact
    contactLabel.text = contact.contact
    descriptionLabel.text = contact.description
    switch contact.type {
    case .email:
      iconImageView.image = Assets.Images.email.image
    case .phone:
      iconImageView.image = Assets.Images.phone.image
    }
  }
  
  // MARK: - Actions
  
  @objc private func handleTap() {
    guard let contact = contact else { return }
    onDidTap?(contact)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupContactLabel()
    setupIconImageView()
    setupDescriptionLabel()
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  private func setupContainer() {
    backgroundColor = UIColor.Light.Surface.secondary
    layer.cornerRadius = 8
    layer.cornerCurve = .continuous
    snp.makeConstraints { make in
      make.height.equalTo(88)
    }
  }
  
  private func setupContactLabel() {
    addSubview(contactLabel)
    contactLabel.setContentHuggingPriority(.required, for: .horizontal)
    contactLabel.textColor = UIColor.Light.Text.primary
    contactLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().inset(16)
    }
  }
  
  private func setupIconImageView() {
    addSubview(iconImageView)
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.snp.makeConstraints { make in
      make.size.equalTo(16)
      make.trailing.equalToSuperview().inset(16)
      make.centerY.equalTo(contactLabel)
      make.leading.equalTo(contactLabel.snp.trailing).offset(8)
    }
  }
  
  private func setupDescriptionLabel() {
    addSubview(descriptionLabel)
    descriptionLabel.numberOfLines = 2
    descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(contactLabel.snp.bottom).offset(4)
      make.leading.trailing.equalToSuperview().inset(16)
      make.bottom.lessThanOrEqualToSuperview().offset(-16)
    }
  }
}
