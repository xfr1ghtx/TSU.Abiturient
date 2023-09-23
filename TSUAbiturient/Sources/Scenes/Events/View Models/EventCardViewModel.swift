//
//  EventCardViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol EventCardViewModelDelegate: AnyObject {
  func eventCardViewModel(_ viewModel: EventCardViewModel, didSelect event: Event)
}

final class EventCardViewModel {
  // MARK: - Properties
  
  var date: String {
    return event.startEndDateDispay
  }
  
  var name: String {
    return event.name
  }
  
  var imageURL: URL? {
    return event.imageURL
  }
  
  weak var delegate: EventCardViewModelDelegate?
  
  private let event: Event
  
  // MARK: - Init
  
  init(event: Event) {
    self.event = event
  }
}

// MARK: - TableCellViewModel

extension EventCardViewModel: TableCellViewModel {
  var tableReuseIdentifier: String {
    EventCardCell.reuseIdentifier
  }
  
  func select() {
    delegate?.eventCardViewModel(self, didSelect: event)
  }
}

// MARK: - Hashable

extension EventCardViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(event)
  }
}

// MARK: - Equatable

extension EventCardViewModel: Equatable {
  static func == (lhs: EventCardViewModel, rhs: EventCardViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
