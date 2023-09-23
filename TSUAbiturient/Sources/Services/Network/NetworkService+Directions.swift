//
//  NetworkService+Directions.swift
//  TSUAbiturient
//

import Foundation

extension NetworkService: EducationDirectionsProtocol {
  func getDirections() async throws -> Directions {
    return try await request(method: .get, url: URLFactory.Directions.calculatorDirections)
  }

  func getDirectionsWithSubjectsData(subjects: [String]) async throws -> Directions {
    var urlString = URLFactory.Directions.calculatorDirections + "?"

    for (index, subject) in subjects.enumerated() {
      if index > 0 {
        urlString += "&"
      }
      urlString += "subjects[]=\(subject)"
    }

    return try await request(method: .get, url: urlString)
  }
}
