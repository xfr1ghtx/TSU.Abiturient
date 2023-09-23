//
//  NetworkService+Events.swift
//  TSUAbiturient
//

import Foundation

extension NetworkService: EventsNetworkProtocol {
  private enum Keys {
    static let dateFrom = "date_from"
    static let dateTo = "date_to"
  }
  
  func getEvents(from startDate: Date, to endDate: Date) async throws -> EventsResponse {
    let formatter = DateFormatter.yearMonthDayISO
    
    let parameters: [String: Any] = [
      Keys.dateFrom: formatter.string(from: startDate),
      Keys.dateTo: formatter.string(from: endDate)
    ]
    
    return try await request(method: .get, url: URLFactory.Events.events, parameters: parameters)
  }
}
