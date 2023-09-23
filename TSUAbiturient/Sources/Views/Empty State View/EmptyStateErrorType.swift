//
//  EmptyStateErrorType.swift
//  TSUAbiturient
//

import UIKit

enum EmptyStateErrorType {
  case noInternet, serverError
  
  var image: UIImage? {
    switch self {
    case .noInternet:
      return nil
    case .serverError:
      return nil
    }
  }
  
  var title: String {
    switch self {
    case .noInternet:
      return Localizable.Errors.NoInternetError.title
    case .serverError:
      return Localizable.Errors.ServerError.title
    }
  }
  
  var subtitle: String {
    switch self {
    case .noInternet:
      return Localizable.Errors.NoInternetError.subtitle
    case .serverError:
      return Localizable.Errors.ServerError.subtitle
    }
  }
}
