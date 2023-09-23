//
//  String+IsEmptyOrNil.swift
//  TSUAbiturient
//

import Foundation

extension Optional where Wrapped == String {
  var isEmptyOrNil: Bool {
    if let value = self {
      return value.isEmpty
    }
    return true
  }
}
