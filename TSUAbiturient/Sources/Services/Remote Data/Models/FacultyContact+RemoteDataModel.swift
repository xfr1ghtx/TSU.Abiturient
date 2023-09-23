//
//  FacultyContact+RemoteDataModel.swift
//  TSUAbiturient
//

import Foundation

extension FacultyContact: RemoteDataModel {
  static var path: String {
    "contacts"
  }
  
  init(remoteData: [String: Any], loadNestedEntities: Bool) async throws {
    guard let id = remoteData["id"] as? Int,
          let contact = remoteData["contact"] as? String,
          let description = remoteData["description"] as? String,
          let type = FacultyContact.FacultyContactType(rawValue: (remoteData["type"] as? String) ?? "") else {
      throw RemoteDataError.failedToDecodeData
    }
    self.init(id: id,
              contact: contact,
              description: description,
              type: type)
  }
}
