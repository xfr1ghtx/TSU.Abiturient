//
//  NetworkServiceError.swift
//  TSUAbiturient
//

import Foundation

enum NetworkServiceError: LocalizedError {
  case failedToDecodeData
  case noData
  case requestFailed
  
  var errorDescription: String? {
    switch self {
    case .failedToDecodeData, .noData:
      return Localizable.Errors.failedToDecodeDataError
    case .requestFailed:
      return Localizable.Errors.requestFailedError
    }
  }
}
