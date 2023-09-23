//
//  UpcommingEventCard.swift
//  TSUAbiturient
//

import UIKit

final class UpcommingEventCard: UIView {
  // MARK: - Properties
  
  var onDidTap: ((Event) -> Void)?
  
  private let dateLabel = Label(textStyle: .body)
  private let nameLabel = Label(textStyle: .bodyBold)
  
  private let event: Event
  
  // MARK: - Init
  
  init(with event: Event) {
    self.event = event
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("UpcommingEventCard init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Actions
  
  @objc
  private func tapOnCard() {
    onDidTap?(event)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupView()
    setupDateLabel()
    setupNameLabel()
  }
  
  private func setupView() {
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnCard)))
    layer.backgroundColor = UIColor.Light.Surface.secondary.cgColor
    layer.cornerRadius = 16
    layer.cornerCurve = .continuous
  }
  
  private func setupDateLabel() {
    addSubview(dateLabel)
    dateLabel.text = event.startDateDispay
    dateLabel.numberOfLines = 1
    dateLabel.textColor = .Light.Text.accent
    dateLabel.snp.makeConstraints { make in
      make.horizontalEdges.top.equalToSuperview().inset(16)
    }
  }
  
  private func setupNameLabel() {
    addSubview(nameLabel)
    nameLabel.numberOfLines = 2
    nameLabel.textColor = .Light.Text.primary
    nameLabel.text = event.name
    nameLabel.adjustsFontSizeToFitWidth = false
    nameLabel.lineBreakMode = .byTruncatingTail
    nameLabel.bottomAlignment = true
    nameLabel.snp.makeConstraints { make in
      make.horizontalEdges.bottom.equalToSuperview().inset(16)
      make.top.equalTo(dateLabel.snp.bottom).offset(4)
      make.height.equalTo(40)
    }
  }
}
