//
//  NetworkService+EducationPrograms.swift
//  TSUAbiturient
//

import Foundation

extension NetworkService: EducationProgramsProtocol {
  func getPriorityPrograms(accountID: String) async throws -> PriorityProgramsResponse {
    return try await request(method: .get,
                             url: URLFactory.EducationPrograms.priorityPrograms(accountID: accountID),
                             authorized: true)
  }
  
  func getEducationPrograms(for requestID: String) async throws -> EducationProgramsResponse {
    // TODO: add token to header
    return try await request(method: .get,
                             url: URLFactory.EducationPrograms.educationPrograms + requestID,
                             authorized: true)
  }
}
