//
//  UIFont+AppFonts.swift
//  TSUAbiturient
//

import UIKit

extension UIFont {
  enum Bold {
    static let app = Fonts.Commissioner.bold.font(size: 16)
    
    static let header1 = scaledFont(for: app.withSize(32), textStyle: .title1)
    static let header2 = scaledFont(for: app.withSize(24), textStyle: .title2)
    static let header3 = scaledFont(for: app.withSize(20), textStyle: .title3)
    static let body = scaledFont(for: app.withSize(16), textStyle: .body)
    static let footnote = scaledFont(for: app.withSize(12), textStyle: .footnote)
  }
  
  enum Regular {
    static let app = Fonts.Commissioner.regular.font(size: 16)
    
    static let body = scaledFont(for: app.withSize(16), textStyle: .body)
    static let footnote = scaledFont(for: app.withSize(12), textStyle: .footnote)
    static let footnoteSmall = scaledFont(for: app.withSize(10), textStyle: .footnote)
  }
  
  static func scaledFont(for font: UIFont?, textStyle: UIFont.TextStyle) -> UIFont? {
    guard let font = font else { return nil }
    return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
  }
}
