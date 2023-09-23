//
//  NetworkProtocols.swift
//  TSUAbiturient
//

import Foundation

protocol NewsNetworkProtocol {
  func getNews(limit: Int,
               since time: TimeInterval) async throws -> [News]
  
  func getNews(withID id: Int) async throws -> NewsDetails
}

protocol EventsNetworkProtocol {
  func getEvents(from startDate: Date,
                 to endDate: Date) async throws -> EventsResponse
}

protocol EducationProgramsProtocol {
  func getEducationPrograms(for requestID: String) async throws -> EducationProgramsResponse
  func getPriorityPrograms(accountID: String) async throws -> PriorityProgramsResponse
}

protocol AuthNetworkProtocol {
  func loginWithTSUAccount(token: String?) async throws -> AuthResponse
  func updateSessionCredentials(with tokens: AuthCredentials?)
}

protocol UserNetworkProtocol {
  func getUserProfileFromLKS() async throws -> UserProfileLKSResponse
  func getUserProfileFromLKA(accountID: String) async throws -> UserProfileLKAResponse
}

protocol EducationDirectionsProtocol {
  func getDirections() async throws -> Directions
  func getDirectionsWithSubjectsData(subjects: [String]) async throws -> Directions
}

protocol DisciplinesProtocol {
  func getDisciplines() async throws -> Disciplines
}
