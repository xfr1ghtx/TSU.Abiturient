//
//  UIView+Wrapped.swift
//  TSUAbiturient
//

import UIKit

extension UIView {
  func wrapped(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)) -> UIView {
    let containerView = UIView()
    containerView.addSubview(self)
    self.snp.makeConstraints { make in
      make.edges.equalTo(insets)
    }
    return containerView
  }
}
