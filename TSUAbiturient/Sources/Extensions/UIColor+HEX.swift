//
//  UIColor+HEX.swift
//  TSUAbiturient
//

import UIKit

extension UIColor {
  convenience init?(hex: String) {
    let red, green, blue, alpha: CGFloat
    
    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      var hexColor = String(hex[start...])
      
      if hexColor.count == 6 {
        hexColor += "FF"
      }
      
      guard hexColor.count == 8 else { return nil }
      
      let scanner = Scanner(string: hexColor)
      var hexNumber: UInt64 = 0
      
      if scanner.scanHexInt64(&hexNumber) {
        red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        alpha = CGFloat(hexNumber & 0x000000ff) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        return
      }
    }
    
    return nil
  }
}
