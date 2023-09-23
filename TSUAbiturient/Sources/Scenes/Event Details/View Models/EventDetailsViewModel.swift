//
//  EventDetailsViewModel.swift
//  TSUAbiturient
//

import Foundation

final class EventDetailsViewModel {
  // MARK: - Properties
  
  var imageURL: URL? {
    event.imageURL
  }
  
  var categoryName: String {
    event.category.name
  }
  
  var name: String {
    event.name
  }
  
  var date: String {
    event.startEndDateDispay
  }
  
  var announce: String {
    event.announce
  }
  
  var address: String? {
    event.address
  }
  
  var addressURL: URL? {
    guard let address = event.address else { return nil}
    return URL(string: address)
  }
  
  var description: String {
    event.description
  }
  
  var addressIsURL: Bool {
    addressURL != nil
  }
  
  private let event: Event
  
  // MARK: - Init
  
  init(event: Event) {
    self.event = event
  }
}
