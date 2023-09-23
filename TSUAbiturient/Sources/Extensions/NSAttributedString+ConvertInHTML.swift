//
//  NSAttributedString+ConvertInHTML.swift
//  TSUAbiturient
//

import Foundation

extension NSAttributedString {
  convenience init?(html: String) {
    guard let data = html.data(using: String.Encoding.unicode, allowLossyConversion: false) else {
      return nil
    }

    guard let attributedString = try? NSMutableAttributedString(data: data,
                                          options: [NSAttributedString.DocumentReadingOptionKey.documentType:
                                          NSAttributedString.DocumentType.html], documentAttributes: nil)
    else {
      return nil
    }

    self.init(attributedString: attributedString)
  }
}
