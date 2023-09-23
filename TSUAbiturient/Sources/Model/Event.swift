//
//  Event.swift
//  TSUAbiturient
//

import Foundation

struct Event: Codable, Hashable {
  let id: Int 
  let name: String
  let startDate: String
  let address: String?
  let announce: String
  let description: String
  let image: String?
  let category: EventCategory
  let endDate: String?
  
  enum CodingKeys: String, CodingKey {
    case id, name, address, announce, description, image, category
    case startDate = "start_date"
    case endDate = "end_date"
  }
}

extension Event {
  var imageURL: URL? {
    URL(string: image ?? "")
  }
  
  var startDateDispay: String {
    if let startDate = DateFormatter.yearMonthDayISO.date(from: startDate) {
      return DateFormatter.dayMonthDisplay.string(from: startDate)
    } else {
      return startDate
    }
  }
  
  var startEndDateDispay: String {
    guard let endDate = endDate else { return startDateDispay }
    return DateFormatter.prettyStringDate(from: startDate, to: endDate)
  }
}
