//
//  CalculatorTagView.swift
//  TSUAbiturient
//

import UIKit

final class CalculatorTagView: UIView {
  // MARK: - Properties
  
  var onDidTapToTag: (() -> Void)?
  
  var tagSelectionState: TagSelectionState = .unselected
  
  private let titleLabel = Label(textStyle: .footnote)
  
  private var text: String
  
  private var isTagClickable: Bool = false
  
  // MARK: - Init
  
  init(withText text: String, isTagClickable: Bool = false) {
    self.text = text
    self.isTagClickable = isTagClickable
    super.init(frame: .zero)
    setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("TagView init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupTitleLabel()
  }
  
  @objc private func handleTapToTagRecognize() {
    onDidTapToTag?()

    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
      if self?.tagSelectionState == .unselected {
        self?.tagSelectionState = .selected
      } else {
        self?.tagSelectionState = .unselected
      }
      
      self?.layer.backgroundColor = self?.tagSelectionState.backgroundColor.cgColor
      self?.titleLabel.textColor = self?.tagSelectionState.textColor
    }
  }
  
  private func setupContainer() {
    layer.cornerRadius = 12
    layer.cornerCurve = .continuous
    layer.backgroundColor = tagSelectionState.backgroundColor.cgColor
    
    let tapToTagRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapToTagRecognize))
    addGestureRecognizer(tapToTagRecognizer)
    isUserInteractionEnabled = isTagClickable
  }
  
  private func setupTitleLabel() {
    titleLabel.textColor = tagSelectionState.textColor
    titleLabel.text = text
    
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview().inset(4)
      make.horizontalEdges.equalToSuperview().inset(8)
    }
  }
}
