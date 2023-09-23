//
//  NetworkService+Disciplines.swift
//  TSUAbiturient
//

import Foundation

extension NetworkService: DisciplinesProtocol {
  func getDisciplines() async throws -> Disciplines {
    return try await request(method: .get, url: URLFactory.Directions.calculatorDisciplines)
  }
}
