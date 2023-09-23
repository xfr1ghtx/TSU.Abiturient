//
//  FacultyCardView.swift
//  TSUAbiturient
//

import UIKit

typealias FacultyCardCell = TableCellContainer<FacultyCardView>

class FacultyCardView: UIView, Configurable {
  // MARK: - Properties
  
  private let mainImageView = UIImageView()
  private let sloganStackView = UIStackView()
  private let titleStackView = UIStackView()
  private let logoImageView = UIImageView()
  private let titleLabel = Label(textStyle: .bodyBold)
  
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
  
  func configure(with viewModel: FacultyCardViewModel) {
    titleLabel.text = viewModel.title
    logoImageView.setImage(with: viewModel.logoURL, placeholder: nil, options: nil)
    mainImageView.setImage(with: viewModel.mainImageURL, placeholder: nil, options: nil)
   
    sloganStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    viewModel.slogan.forEach { text in
      let label = createSloganLabel(text: text)
      label.backgroundColor = viewModel.sloganColor
      sloganStackView.addArrangedSubview(label)
    }
    setupSloganStackViewConstraints(for: viewModel.sloganPosition)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupMainImageView()
    setupSloganStackView()
    setupTitleStackView()
    setupLogoImageView()
    setupTitleLabel()
  }
  
  private func setupContainer() {
    backgroundColor = UIColor.Light.Surface.primary
    addShadow(offset: CGSize(width: 0, height: 12), radius: 24, color: UIColor.Light.Global.black, opacity: 0.08)
    layer.cornerRadius = 24
    layer.cornerCurve = .continuous
  }

  private func setupMainImageView() {
    addSubview(mainImageView)
    mainImageView.layer.cornerRadius = 24
    mainImageView.layer.cornerCurve = .continuous
    mainImageView.contentMode = .scaleAspectFill
    mainImageView.clipsToBounds = true
    mainImageView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(168)
    }
  }
  
  private func setupSloganStackView() {
    addSubview(sloganStackView)
    sloganStackView.axis = .vertical
    sloganStackView.spacing = 0
  }
  
  private func setupTitleStackView() {
    addSubview(titleStackView)
    titleStackView.axis = .horizontal
    titleStackView.alignment = .center
    titleStackView.spacing = 8
    titleStackView.snp.makeConstraints { make in
      make.top.equalTo(mainImageView.snp.bottom).offset(16)
      make.leading.trailing.bottom.equalToSuperview().inset(16)
    }
  }
  
  private func setupLogoImageView() {
    titleStackView.addArrangedSubview(logoImageView)
    logoImageView.contentMode = .scaleAspectFill
    logoImageView.layer.cornerRadius = 20
    logoImageView.clipsToBounds = true
    logoImageView.snp.makeConstraints { make in
      make.size.equalTo(40)
    }
  }
  
  private func setupTitleLabel() {
    titleStackView.addArrangedSubview(titleLabel)
    titleLabel.textColor = UIColor.Light.Text.primary
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .left
  }
  
  private func setupSloganStackViewConstraints(for position: Faculty.SloganPosition) {
    switch position {
    case .topLeft:
      sloganStackView.alignment = .leading
      sloganStackView.snp.remakeConstraints { make in
        make.top.leading.equalTo(mainImageView).inset(24)
      }
    case .topRight:
      sloganStackView.alignment = .trailing
      sloganStackView.snp.remakeConstraints { make in
        make.top.trailing.equalTo(mainImageView).inset(24)
      }
    case .bottomLeft:
      sloganStackView.alignment = .leading
      sloganStackView.snp.remakeConstraints { make in
        make.bottom.leading.equalTo(mainImageView).inset(24)
      }
    case .bottomRight:
      sloganStackView.alignment = .trailing
      sloganStackView.snp.remakeConstraints { make in
        make.bottom.trailing.equalTo(mainImageView).inset(24)
      }
    }
  }
  
  private func createSloganLabel(text: String) -> UIView {
    let containerView = UIView()
    let label = Label(textStyle: .header3)
    label.text = text.uppercased()
    label.textColor = UIColor.Light.Text.white
    containerView.addSubview(label)
    label.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(4)
      make.top.bottom.equalToSuperview()
    }
    return containerView
  }
}

// MARK: - PaddingsDescribing

extension FacultyCardView: PaddingsDescribing {
  var paddings: UIEdgeInsets {
    UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
  }
}
