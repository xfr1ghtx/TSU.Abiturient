//
//  TextView.swift
//  TSUAbiturient
//

import UIKit

protocol TextViewDelegate: AnyObject {
  func textViewDidChange(_ textView: TextView)
  func textView(_ textView: TextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

extension TextViewDelegate {
  func textViewDidChange(_ textView: TextView) {}
  func textView(_ textView: TextView, shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    return true
  }
}

class TextView: UIView {
  // MARK: - Properties
  
  weak var delegate: TextViewDelegate?
  
  var placeholder: String? {
    get {
      placeholderLabel.text
    }
    set {
      placeholderLabel.text = newValue
    }
  }
  
  var text: String {
    get {
      textView.text
    }
    set {
      textView.text = newValue
    }
  }
  
  private let textView = UITextView()
  private let placeholderLabel = Label(textStyle: .body)
  
  // MARK: - Init
  
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupTextView()
    setupPlaceholderLabel()
  }
  
  private func setupTextView() {
    addSubview(textView)
    textView.textContainerInset = .zero
    textView.contentInset = UIEdgeInsets(top: 0.5, left: 0, bottom: 0, right: 0)
    textView.textContainer.lineFragmentPadding = 0
    textView.font = .Regular.body
    textView.textColor = .Light.Global.black
    textView.tintColor = .systemBlue
    textView.delegate = self
    textView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupPlaceholderLabel() {
    addSubview(placeholderLabel)
    placeholderLabel.textColor = .systemGray
    placeholderLabel.numberOfLines = 0
    placeholderLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview()
    }
  }
}

// MARK: - UITextViewDelegate

extension TextView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    placeholderLabel.isHidden = !textView.text.isEmpty
    delegate?.textViewDidChange(self)
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    return delegate?.textView(self, shouldChangeTextIn: range, replacementText: text) ?? true
  }
}
