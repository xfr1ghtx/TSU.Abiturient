//
//  RemoteDataModel.swift
//  TSUAbiturient
//

import Foundation

protocol RemoteDataModel: Codable {
  static var path: String { get }
  
  init(remoteData: [String: Any], loadNestedEntities: Bool) async throws
}
