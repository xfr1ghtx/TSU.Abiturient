//
//  DefaultKeyboardToolbar.swift
//  TSUAbiturient
//

import UIKit

class DefaultKeyboardToolbar: UIToolbar {
  // MARK: - Properties
  
  var onDidTapDone: (() -> Void)?
  
  private let doneButton = UIBarButtonItem(title: Localizable.Common.done, style: .done,
                                           target: self, action: #selector(handleTapDone))
  
  // MARK: - Init
  
  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Actions
  
  @objc private func handleTapDone() {
    onDidTapDone?()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupDoneButton()
    setupBar()
  }
  
  private func setupDoneButton() {
    doneButton.tintColor = .systemBlue
    
    let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.Bold.body ?? .boldSystemFont(ofSize: 16)]
    doneButton.setTitleTextAttributes(attributes, for: .normal)
    doneButton.setTitleTextAttributes(attributes, for: .highlighted)
  }
  
  private func setupBar() {
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    items = [flexibleSpace, doneButton]
    sizeToFit()
    barTintColor = .systemGray5
  }
}
