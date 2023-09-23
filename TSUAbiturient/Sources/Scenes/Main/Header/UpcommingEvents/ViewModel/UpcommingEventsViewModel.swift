//
//  UpcommingEventsViewModel.swift
//  TSUAbiturient
//

import Foundation

private extension Constants {
  static let threeMouthTimeInterval = TimeInterval(7257600)
  
  static let testTimeInterval = TimeInterval(29030400)
}

protocol UpcommingEventsViewModelDelegate: AnyObject {
  func upcommingEventsViewModel(_ upcommingEventsViewModel: UpcommingEventsViewModel,
                                didRequestToShow event: Event)
  func upcommingEventsViewModel(_ upcommingEventsViewModel: UpcommingEventsViewModel,
                                didRequestToShow events: [Event])
  func upcommingEventsViewModelDidRequestToShowView(_ upcommingEventsViewModel: UpcommingEventsViewModel)
}

final class UpcommingEventsViewModel: DataLoadingViewModel {
  typealias Dependencies = HasEventsService
  // MARK: - Properties
  
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  
  weak var delegate: UpcommingEventsViewModelDelegate?
  
  private(set) var events: [Event] = []
  private let dependencies: Dependencies
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public methods
  
  func loadData() {
    onDidStartRequest?()
    Task {
      do {
        let eventsResponse = try await dependencies.eventsService.getEvents(from: Date(),
                                                                            to: Date().addingTimeInterval(Constants.threeMouthTimeInterval))
        await MainActor.run {
          handle(events: eventsResponse.data)
        }
      } catch let error {
        await MainActor.run {
          handle(error: error)
        }
      }
    }
  }
  
  func didTapOnCardWith(event: Event) {
    delegate?.upcommingEventsViewModel(self, didRequestToShow: event)
  }
  
  func didTapOnView() {
    delegate?.upcommingEventsViewModel(self, didRequestToShow: events)
  }
  
  // MARK: - Private methods
  
  private func handle(error: Error) {
    onDidFinishRequest?()
    onDidReceiveError?(error)
  }
  
  private func handle(events: [Event]) {
    self.events = events.sorted {
      guard let fistDate = DateFormatter.yearMonthDayISO.date(from: $0.startDate),
            let secondDate = DateFormatter.yearMonthDayISO.date(from: $1.startDate) else {
        return true
      }
      return fistDate < secondDate
      
    }
    if !events.isEmpty {
      delegate?.upcommingEventsViewModelDidRequestToShowView(self)
    }
    onDidFinishRequest?()
    onDidLoadData?()
  }
}
