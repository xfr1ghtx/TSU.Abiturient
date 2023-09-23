//
//  DataStoreProtocol.swift
//  TSUAbiturient
//

import Foundation

protocol DataStoreProtocol: AnyObject {
  var observer: DataStoreObserver { get }
  
  var userProfile: UserProfile? { get set }
  
  func clearAllData()
}
