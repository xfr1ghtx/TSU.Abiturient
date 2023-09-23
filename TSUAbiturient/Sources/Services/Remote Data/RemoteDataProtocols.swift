//
//  RemoteDataProtocols.swift
//  TSUAbiturient
//

import Foundation

protocol FacultiesRemoteDataProtocol {
  func getFaculties() async throws -> [Faculty]
  func getFaculty(id: Int) async throws -> Faculty?
}

protocol BuildingsRemoteDataProtocol {
  func getBuildings() async throws -> [Building]
}
