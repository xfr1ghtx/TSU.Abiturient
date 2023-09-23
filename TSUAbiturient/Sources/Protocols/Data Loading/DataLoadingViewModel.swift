//
//  DataLoadingViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol DataLoadingViewModel: AnyObject {
  var onDidStartRequest: (() -> Void)? { get set }
  var onDidFinishRequest: (() -> Void)? { get set }
  var onDidLoadData: (() -> Void)? { get set }
  var onDidReceiveError: ((Error) -> Void)? { get set }
}
