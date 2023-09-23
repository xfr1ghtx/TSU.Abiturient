//
//  Array+ElementAt.swift
//  TSUAbiturient
//

import Foundation

extension Array {
  func element(at index: Int) -> Array.Element? {
    guard index >= 0, index < count else { return nil }
    return self[index]
  }
}
