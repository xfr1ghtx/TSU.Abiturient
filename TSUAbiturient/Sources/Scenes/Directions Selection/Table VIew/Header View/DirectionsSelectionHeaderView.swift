//
//  DirectionsSelectionHeaderView.swift
//  TSUAbiturient
//

import UIKit

typealias DirectionsSelectionHeader = TableHeaderFooterContainer<DirectionsSelectionHeaderView>

final class DirectionsSelectionHeaderView: UIView, Configurable {
  // MARK: - Properties
  
  private var clearSubjectsClosure: (() -> Void)?
  
  private let horizontalStackView = UIStackView()
  private let chooseSubjectsLabel = Label(textStyle: .body)
  let resetSubjectsScoreLabel = Label(textStyle: .body)
  
  // MARK: - Init
  
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Configuration
  
  func configure(with viewModel: DirectionsSelectionHeaderViewModel) {
    chooseSubjectsLabel.text = nil
    resetSubjectsScoreLabel.text = nil
    resetSubjectsScoreLabel.alpha = viewModel.isResetButtonAccessed ? 1 : 0
    
    chooseSubjectsLabel.text = Localizable.Calculator.indicateResults
    resetSubjectsScoreLabel.text = Localizable.Common.reset
    
    viewModel.changeAccessInResetButton = { [weak self] value in
      self?.resetSubjectsScoreLabel.alpha = value ? 1 : 0
    }
    
    resetSubjectsScoreLabel.isUserInteractionEnabled = true
    
    let labelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnLabel))
    resetSubjectsScoreLabel.addGestureRecognizer(labelGestureRecognizer)
    
    clearSubjectsClosure = { [weak self] in
      viewModel.clearSubjectsData()
      self?.resetSubjectsScoreLabel.alpha = viewModel.isResetButtonAccessed ? 1 : 0
    }
  }
  
  @objc private func tapOnLabel() {
    clearSubjectsClosure?()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupHorizontalStackView()
    setupChooseSubjectsLabel()
    setupResetSubjectsScoreLabel()
  }
  
  private func setupHorizontalStackView() {
    addSubview(horizontalStackView)
    horizontalStackView.axis = .horizontal
    horizontalStackView.spacing = 16
    
    horizontalStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupChooseSubjectsLabel() {
    horizontalStackView.addArrangedSubview(chooseSubjectsLabel)
    chooseSubjectsLabel.textColor = .Light.Text.secondary
  }
  
  private func setupResetSubjectsScoreLabel() {
    horizontalStackView.addArrangedSubview(resetSubjectsScoreLabel)
    resetSubjectsScoreLabel.textColor = .Light.Text.accent
  }
}

// MARK: - Paddings

extension DirectionsSelectionHeaderView: PaddingsDescribing {
  var paddings: UIEdgeInsets {
    return UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
  }
}
