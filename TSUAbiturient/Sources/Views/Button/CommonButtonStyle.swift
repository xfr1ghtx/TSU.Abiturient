//
//  CommonButtonStyle.swift
//  TSUAbiturient
//

import UIKit

enum CommonButtonStyle {

  case `default`
  
  var backgroundColor: UIColor {
    return .Light.Button.Primary.background
  }
  
  var highlightedBackgroundColor: UIColor {
    return .Light.Button.Primary.backgroundPressed
  }
  
  var disabledBackgroundColor: UIColor {
    return .Light.Button.Primary.backgroundDisabled
  }
  
  var textColor: UIColor {
    return .Light.Button.Primary.title
  }
  
  var highlightedTextColor: UIColor {
    return .Light.Button.Primary.title
  }
  
  var disabledTextColor: UIColor {
    return .Light.Button.Primary.title
  }
  
  var height: CGFloat {
    return 48
  }
  
  var font: UIFont? {
    return .Bold.body
  }
}
