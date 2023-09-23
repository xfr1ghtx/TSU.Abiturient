//
//  DataStoreObserver.swift
//  TSUAbiturient
//

import Foundation

enum DataStoreEvent {
  case userProfileUpdated
}

protocol DataStoreSubscriber: AnyObject {
  func update(event: DataStoreEvent)
}

class DataStoreObserver {
  private var subscribers: [DataStoreSubscriber] = []
  
  func subscribe(_ subscriber: DataStoreSubscriber) {
    subscribers.append(subscriber)
  }
  
  func unsubscribe(_ subscriber: DataStoreSubscriber) {
    subscribers.removeAll { $0 === subscriber }
  }
  
  func notify(event: DataStoreEvent) {
    subscribers.forEach { $0.update(event: event) }
  }
}
