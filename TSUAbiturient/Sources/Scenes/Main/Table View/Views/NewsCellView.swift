//
//  NewsCellView.swift
//  TSUAbiturient
//

import UIKit

typealias NewsCell = TableCellContainer<NewsCellView>

final class NewsCellView: UIView, Configurable {
  // MARK: - Properties
  
  private let stackViewContainer = UIStackView()
  private let previewImageView = UIImageView()
  private let titleLabel = Label(textStyle: .bodyBold)
  private let dateLabel = Label(textStyle: .footnote)
  
  // MARK: - Inits
  
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Configure
  
  func configure(with viewModel: NewsCellViewModel) {
    self.previewImageView.image = nil
    self.titleLabel.text = nil
    self.dateLabel.text = nil
    
    self.previewImageView.setImage(with: viewModel.previewImageURL,
                                   placeholder: Assets.Images.cellPlaceholder.image,
                                   options: [.backgroundDecode])
    self.titleLabel.text = viewModel.title
    self.dateLabel.text = viewModel.date 
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupStackViewContainer()
    setupPreviewImageView()
    setupTitleLabel()
    setupDateLabel()
  }
  
  private func setupContainer() {
    backgroundColor = .Light.Surface.primary
    addShadow(offset: CGSize(width: 0, height: 8), radius: 12, color: .Light.Global.black, opacity: 0.08)
    layer.cornerRadius = 24
    layer.cornerCurve = .continuous
  }
  
  private func setupStackViewContainer() {
    addSubview(stackViewContainer)
    stackViewContainer.axis = .vertical
    stackViewContainer.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(16)
    }
  }
  
  private func setupPreviewImageView() {
    previewImageView.layer.cornerCurve = .continuous
    previewImageView.layer.cornerRadius = 8
    previewImageView.clipsToBounds = true
    previewImageView.contentMode = .scaleAspectFill
    previewImageView.snp.makeConstraints { make in
      make.height.equalTo(200)
    }
    stackViewContainer.addArrangedSubview(previewImageView)
    stackViewContainer.setCustomSpacing(16, after: previewImageView)
  }
  
  private func setupTitleLabel() {
    titleLabel.textColor = .Light.Text.primary
    titleLabel.numberOfLines = 0
    stackViewContainer.addArrangedSubview(titleLabel)
    stackViewContainer.setCustomSpacing(8, after: titleLabel)
  }
  
  private func setupDateLabel() {
    dateLabel.textColor = .Light.Text.secondary
    stackViewContainer.addArrangedSubview(dateLabel)
  }
}

// MARK: - PaddingDescribing

extension NewsCellView: PaddingsDescribing {
  var paddings: UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
  }
}
