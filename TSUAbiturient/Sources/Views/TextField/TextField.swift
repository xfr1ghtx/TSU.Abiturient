//
//  TextField.swift
//  TSUAbiturient
//

import UIKit

private extension Constants {
  static let defaultTextFieldPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
}

protocol TextFieldDelegate: AnyObject {
  func textFieldShouldReturn(_ textField: TextField) -> Bool
  func textFieldDidBeginEditing(_ textField: TextField)
  func textFieldDidEndEditing(_ textField: TextField)
  func textFieldDidChangeSelection(_ textField: TextField)
}

extension TextFieldDelegate {
  func textFieldShouldReturn(_ textField: TextField) -> Bool {
    return true
  }

  func textFieldDidBeginEditing(_ textField: TextField) {}
  func textFieldDidEndEditing(_ textField: TextField) {}
  func textFieldDidChangeSelection(_ textField: TextField) {}
}

class TextField: UIView {
  // MARK: - Properties
  
  weak var delegate: TextFieldDelegate?
  
  var onChange: ((_ text: String?) -> Void)?
  
  var hasClearButton: Bool = false {
    didSet {
      updateClearButtonState()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    CGSize(width: textField.intrinsicContentSize.width, height: 44)
  }
  
  let textField: CustomPaddingTextField
  private let clearButton = UIButton(type: .system)
  
  // MARK: - Init
  
  init(padding: UIEdgeInsets = Constants.defaultTextFieldPadding) {
    textField = CustomPaddingTextField(padding: padding)
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    textField = CustomPaddingTextField(padding: Constants.defaultTextFieldPadding)
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Actions
  
  @objc private func onDidChange() {
    onChange?(textField.text)
    updateClearButtonState()
  }
  
  @objc func clearText() {
    textField.text = nil
    onDidChange()
    endEditing(true)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupTextField()
    setupClearButton()
  }
  
  private func setupContainer() {
    backgroundColor = .systemGray6
    layer.cornerRadius = 4
  }
  
  private func setupTextField() {
    addSubview(textField)
    textField.tintColor = .systemBlue
    textField.font = .Regular.body
    textField.textColor = .Light.Global.black
    textField.adjustsFontForContentSizeCategory = true
    textField.delegate = self
    textField.addTarget(self, action: #selector(onDidChange), for: .editingChanged)
    textField.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupClearButton() {
    clearButton.setImage(UIImage(systemName: "multiply.circle.fill"),
                         for: .normal)
    clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
    clearButton.imageView?.contentMode = .center
    clearButton.snp.makeConstraints { make in
      make.width.equalTo(40)
      make.height.equalTo(44)
    }
    updateClearButtonState()
  }
  
  // MARK: - Private methods
  
  private func updateClearButtonState() {
    if hasClearButton, !textField.text.isEmptyOrNil {
      textField.rightView = clearButton
      textField.rightViewMode = .always
    } else {
      textField.rightView = nil
      textField.rightViewMode = .never
    }
  }
}

// MARK: - Public properties

extension TextField {
  var text: String? {
    get {
      textField.text
    }
    set {
      textField.text = newValue
    }
  }

  var placeholder: String? {
    get {
      textField.attributedPlaceholder?.string
    }
    set {
      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.Regular.body ?? .systemFont(ofSize: 16),
        .foregroundColor: UIColor.systemGray
      ]
      textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "",
                                                           attributes: attributes)
    }
  }
  
  var keyboardType: UIKeyboardType {
    get {
      textField.keyboardType
    }
    set {
      textField.keyboardType = newValue
    }
  }
  
  var returnKeyType: UIReturnKeyType {
    get {
      textField.returnKeyType
    }
    set {
      textField.returnKeyType = newValue
    }
  }
  
  var isSecureTextEntry: Bool {
    get {
      textField.isSecureTextEntry
    }
    set {
      textField.isSecureTextEntry = newValue
    }
  }
  
  var autocorrectionType: UITextAutocorrectionType {
    get {
      textField.autocorrectionType
    }
    set {
      textField.autocorrectionType = newValue
    }
  }
  
  var autocapitalizationType: UITextAutocapitalizationType {
    get {
      textField.autocapitalizationType
    }
    set {
      textField.autocapitalizationType = newValue
    }
  }

  var leftView: UIView? {
    get {
      textField.leftView
    }
    set {
      textField.leftView = newValue
    }
  }

  var leftViewMode: UITextField.ViewMode {
    get {
      textField.leftViewMode
    }
    set {
      textField.leftViewMode = newValue
    }
  }

  var canPerformAction: Bool? {
    get {
      textField.canPerformAction
    }
    set {
      textField.canPerformAction = newValue
    }
  }

  var fieldTintColor: UIColor {
    get {
      textField.tintColor
    }
    set {
      textField.tintColor = newValue
    }
  }

  var selectedTextRange: UITextRange? {
    get {
      textField.selectedTextRange
    }
    set {
      textField.selectedTextRange = newValue
    }
  }

  var accessoryView: UIView? {
    get {
      textField.inputAccessoryView
    }
    set {
      textField.inputAccessoryView = newValue
    }
  }

  override var inputView: UIView? {
    get {
      textField.inputView
    }
    set {
      textField.inputView = newValue
    }
  }
  
  override var isFirstResponder: Bool {
    textField.isFirstResponder
  }
}

// MARK: - UITextFieldDelegate

extension TextField: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return delegate?.textFieldShouldReturn(self) ?? true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    delegate?.textFieldDidBeginEditing(self)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    delegate?.textFieldDidEndEditing(self)
  }

  func textFieldDidChangeSelection(_ textField: UITextField) {
    delegate?.textFieldDidChangeSelection(self)
  }
}

// MARK: - CustomPaddingTextField

class CustomPaddingTextField: UITextField {
  var canPerformAction: Bool?

  private let padding: UIEdgeInsets

  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    return canPerformAction ?? super.canPerformAction(action, withSender: sender)
  }
  
  init(padding: UIEdgeInsets) {
    self.padding = padding
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    padding = .zero
    super.init(coder: coder)
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.inset(by: padding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.editingRect(forBounds: bounds)
    return rect.inset(by: padding)
  }
}
