//
//  FacultyLink+RemoteDataModel.swift
//  TSUAbiturient
//

import Foundation

extension FacultyLink: RemoteDataModel {
  static var path: String {
    "links"
  }
  
  init(remoteData: [String: Any], loadNestedEntities: Bool) async throws {
    guard let id = remoteData["id"] as? Int,
          let link = remoteData["link"] as? String,
          let description = remoteData["description"] as? String,
          let type = FacultyLink.FacultyLinkType(rawValue: (remoteData["type"] as? String) ?? "") else {
      throw RemoteDataError.failedToDecodeData
    }
    self.init(id: id,
              link: link,
              description: description,
              type: type)
  }
}
