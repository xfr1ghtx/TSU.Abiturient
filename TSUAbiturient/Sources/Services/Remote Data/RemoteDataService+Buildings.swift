//
//  RemoteDataService+Buildings.swift
//  TSUAbiturient
//

import Foundation

extension RemoteDataService: BuildingsRemoteDataProtocol {
  func getBuildings() async throws -> [Building] {
    return try await getCollection(type: Building.self, loadNestedEntities: false)
  }
}
