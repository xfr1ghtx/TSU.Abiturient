//
//  TextField+DoneButton.swift
//  TSUAbiturient
//

import UIKit

extension UITextField {
  @IBInspectable var doneAccessory: Bool {
    get {
      return self.doneAccessory
    }
    set(hasDone) {
      if hasDone {
        self.addDoneButtonOnKeyboard()
      }
    }
  }

  func addDoneButtonOnKeyboard() {
    let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    doneToolbar.barStyle = .default

    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem(title: Localizable.Common.done,
                               style: .done,
                               target: self,
                               action: #selector(self.doneButtonAction))

    let items = [flexSpace, done]
    doneToolbar.items = items
    doneToolbar.sizeToFit()

    self.inputAccessoryView = doneToolbar
  }

  @objc func doneButtonAction() {
    self.resignFirstResponder()
  }
}
