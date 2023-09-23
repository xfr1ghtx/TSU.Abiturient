//
//  EventCardView.swift
//  TSUAbiturient
//

import UIKit

typealias EventCardCell = TableCellContainer<EventCardView>

final class EventCardView: UIView, Configurable {
  // MARK: - Properties
  
  private let containerStackView = UIStackView()
  private let dateLabel = Label(textStyle: .footnoteBold)
  private let nameLabel = Label(textStyle: .bodyBold)
  private let imageView = UIImageView()
  
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
  
  func configure(with viewModel: EventCardViewModel) {
    dateLabel.text = nil
    nameLabel.text = nil
    imageView.image = nil
    
    dateLabel.text = viewModel.date
    nameLabel.text = viewModel.name
    imageView.setImage(with: viewModel.imageURL, placeholder: Assets.Images.cellPlaceholder.image, options: nil)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupView()
    setupContainerStackView()
    setupDateLabel()
    setupNameLabel()
    setupImageView()
  }
  
  private func setupView() {
    backgroundColor = .Light.Surface.primary
    addShadow(offset: CGSize(width: 0, height: 8), radius: 12, color: .Light.Global.black, opacity: 0.08)
    layer.cornerRadius = 24
    layer.cornerCurve = .continuous
  }
  
  private func setupContainerStackView() {
    addSubview(containerStackView)
    containerStackView.axis = .vertical
    containerStackView.spacing = 8
    
    containerStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(16)
    }
  }
  
  private func setupDateLabel() {
    containerStackView.addArrangedSubview(dateLabel)
    dateLabel.textColor = .Light.Text.accent
  }
  
  private func setupNameLabel() {
    containerStackView.addArrangedSubview(nameLabel)
    nameLabel.textColor = .Light.Text.primary
    nameLabel.numberOfLines = 0
    containerStackView.setCustomSpacing(16, after: nameLabel)
  }
  
  private func setupImageView() {
    containerStackView.addArrangedSubview(imageView)
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerCurve = .continuous
    imageView.layer.cornerRadius = 8
    imageView.layer.masksToBounds = true
    imageView.snp.makeConstraints { make in
      make.height.equalTo(200)
    }
  }
}

// MARK: - PaddingDescribing

extension EventCardView: PaddingsDescribing {
  var paddings: UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
  }
}
