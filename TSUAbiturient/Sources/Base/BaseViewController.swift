//
//  BaseViewController.swift
//  TSUAbiturient
//

import SnapKit
import UIKit

class BaseViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    view.backgroundColor = .Light.Surface.primary
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}
