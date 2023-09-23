//
//  Building+RemoteDataModel.swift
//  TSUAbiturient
//

import Foundation

extension Building: RemoteDataModel {
  static var path: String {
    "Locations"
  }
  
  init(remoteData: [String: Any], loadNestedEntities: Bool) async throws {
    guard let id = remoteData["id"] as? Int,
          let name = remoteData["name"] as? String,
          let address = remoteData["address"] as? String,
          let latitude = remoteData["latitude"] as? Double,
          let longitude = remoteData["longitude"] as? Double,
          let type = Building.BuildingType(rawValue: (remoteData["type"] as? String) ?? "") else {
      throw RemoteDataError.failedToDecodeData
    }
    self.init(id: id,
              address: address,
              latitude: latitude,
              longitude: longitude,
              name: name,
              type: type)
  }
}
