//
//  DirectionView.swift
//  TSUAbiturient
//

import UIKit

// MARK: - DirectionView

final class DirectionView: UIView {
  // MARK: - Properties
  
  private let labelsContainer = UIStackView()
  private var directionNameLabel: Label
  private let facultyAndPriorityLabel = Label(textStyle: .footnote)
  private var positionView: UIView?
  
  private let direction: RatingDirection
  
  private let labelWidth: CGFloat
  
  // MARK: - Init
  
  init(with direction: RatingDirection, labelWidth width: CGFloat) {
    self.direction = direction
    labelWidth = width
    directionNameLabel = Label(textStyle: direction.priority == 1 ? .header3 : .bodyBold)
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("DirectionView init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupPositionView()
    setupLabelsContainer()
    setupDirectionNameLabel()
    setupFacultyAndPriorityLabel()
  }
  
  private func setupPositionView() {
    guard let color = direction.color, let place = direction.place else { return }
    let positionView = direction.priority == 1 ? PrimaryPositionView(with: place, color: color.color, labelWidth: labelWidth)
    : SecondaryPositionView(with: place, color: color.color, labelWidth: labelWidth)
    addSubview(positionView)
    
    positionView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
      make.height.equalTo(direction.priority == 1 ? 32 : 28)
    }
    
    self.positionView = positionView
    
  }
  
  private func setupLabelsContainer() {
    addSubview(labelsContainer)
    labelsContainer.spacing = 4
    labelsContainer.axis = .vertical
    
    labelsContainer.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(direction.priority == 1 ? 16 : 8)
      make.trailing.equalToSuperview().inset(16)
      guard let positionView = positionView else { return }
      make.leading.equalTo(positionView.snp.trailing).offset(direction.priority == 1 ? 8 : 16)
    }
  }
  
  private func setupDirectionNameLabel() {
    labelsContainer.addArrangedSubview(directionNameLabel)
    directionNameLabel.text = direction.name
    directionNameLabel.textColor = .Light.Text.primary
    directionNameLabel.numberOfLines = 0
  }
  
  private func setupFacultyAndPriorityLabel() {
    labelsContainer.addArrangedSubview(facultyAndPriorityLabel)
    facultyAndPriorityLabel.text = "\(direction.faculty) • \(direction.priority)-й приоритет"
    facultyAndPriorityLabel.textColor = .Light.Text.secondary
    facultyAndPriorityLabel.numberOfLines = 0
  }
}
