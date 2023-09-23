//
//  EventsViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol EventsViewModelDelegate: AnyObject {
  func eventsViewModel(_ viewModel: EventsViewModel, didRequestToShow event: Event)
}

final class EventsViewModel {
  // MARK: - Properties
  
  weak var delegate: EventsViewModelDelegate?
  
  private(set) var tableItems: [EventsListSections: [EventCardViewModel]] = [:]
  
  // MARK: - Init
  
  init(with events: [Event]) {
    let viewModels = events.map { EventCardViewModel(event: $0) }
    
    viewModels.forEach { viewModel in
      viewModel.delegate = self
    }
    
    if tableItems[.events] != nil {
      tableItems[.events]?.append(contentsOf: viewModels)
    } else {
      tableItems[.events] = viewModels
    }
  }
}

// MARK: - EventCardViewModelDelegate
extension EventsViewModel: EventCardViewModelDelegate {
  func eventCardViewModel(_ viewModel: EventCardViewModel, didSelect event: Event) {
    delegate?.eventsViewModel(self, didRequestToShow: event)
  }
}
