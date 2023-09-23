//
//  NetworkServiceErrorUtility.swift
//  TSUAbiturient
//

import Foundation

private extension Constants {
  static let noInternetErrorCodes = [NSURLErrorCallIsActive, NSURLErrorCannotConnectToHost, NSURLErrorCannotFindHost,
                                     NSURLErrorCannotLoadFromNetwork, NSURLErrorDataNotAllowed, NSURLErrorInternationalRoamingOff,
                                     NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet,
                                     NSURLErrorSecureConnectionFailed, NSURLErrorTimedOut, alamofireNoInternetCode]
  static let alamofireNoInternetCode = 13
}

class NetworkServiceErrorUtility {
  static func isNoInternetError(_ error: Error) -> Bool {
    return Constants.noInternetErrorCodes.contains((error as NSError).code)
  }
}
