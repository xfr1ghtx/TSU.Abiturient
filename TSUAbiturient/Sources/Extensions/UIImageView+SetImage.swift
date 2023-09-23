//
//  UIImageView+SetImage.swift
//  TSUAbiturient
//

import Kingfisher
import UIKit

extension UIImageView {
  func setImage(with url: URL?, placeholder: Placeholder?, options: KingfisherOptionsInfo?) {
    kf.setImage(with: url, placeholder: placeholder, options: options)
  }
}
