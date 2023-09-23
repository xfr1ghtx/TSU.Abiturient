//
//  EmptyStateErrorView.swift
//  TSUAbiturient
//

import UIKit

class EmptyStateErrorView: UIView {
  // MARK: - Private methods
  
  var onDidTapRefreshButton: (() -> Void)?
  
  private let stackView = UIStackView()
  private let imageView = UIImageView()
  private let titleLabel = Label(textStyle: .bodyBold)
  private let subtitleLabel = Label(textStyle: .body)
  private let refreshButton = UIButton(type: .system)
 
  // MARK: - Init
  
  init() {
    super.init(frame: .zero)
    setup()
    imageView.image = nil
    titleLabel.text = ""
    subtitleLabel.text = ""
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Configure
  
  func configure(for type: EmptyStateErrorType) {
    imageView.image = type.image
    titleLabel.text = type.title
    subtitleLabel.text = type.subtitle
  }
  
  // MARK: - Actions
  
  @objc private func didTapRefreshButton() {
    onDidTapRefreshButton?()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupStackView()
    setupImageView()
    setupTitleLabel()
    setupSubtitleLabel()
    setupRefreshButton()
  }
  
  private func setupStackView() {
    addSubview(stackView)
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.alignment = .center
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupImageView() {
    stackView.addArrangedSubview(imageView)
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { make in
      make.height.equalTo(220)
      make.leading.trailing.equalToSuperview()
    }
  }
  
  private func setupTitleLabel() {
    stackView.addArrangedSubview(titleLabel)
    stackView.setCustomSpacing(4, after: titleLabel)
    titleLabel.textColor = .Light.Global.black
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
    }
  }
  
  private func setupSubtitleLabel() {
    stackView.addArrangedSubview(subtitleLabel)
    subtitleLabel.textColor = .Light.Global.black
    subtitleLabel.numberOfLines = 0
    subtitleLabel.textAlignment = .center
    subtitleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
    }
  }
  
  private func setupRefreshButton() {
    stackView.addArrangedSubview(refreshButton)
    refreshButton.setTitle(Localizable.Common.refresh, for: .normal)
    refreshButton.addTarget(self, action: #selector(didTapRefreshButton), for: .touchUpInside)
  }
}
