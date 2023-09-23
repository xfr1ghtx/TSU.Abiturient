//
//  TextStyle.swift
//  TSUAbiturient
//

import UIKit

enum TextStyle {
  case header1, header2, header3, body, bodyBold, footnote, footnoteBold, smallFootnote

  var fontSize: CGFloat {
    self.font?.pointSize ?? 0
  }

  var lineHeight: CGFloat {
    switch self {
    case .header1:
      return 40
    case .header2:
      return 32
    case .header3:
      return 24
    case .body:
      return 20
    case .bodyBold:
      return 20
    case .footnote:
      return 16
    case .footnoteBold:
      return 16
    case .smallFootnote:
      return 12
    }
  }

  var font: UIFont? {
    switch self {
    case .header1:
      return .Bold.header1
    case .header2:
      return .Bold.header2
    case.header3:
      return .Bold.header3
    case .body:
      return .Regular.body
    case .bodyBold:
      return .Bold.body
    case .footnote:
      return .Regular.footnote
    case .footnoteBold:
      return .Bold.footnote
    case .smallFootnote:
      return .Regular.footnoteSmall
    }
  }
}
