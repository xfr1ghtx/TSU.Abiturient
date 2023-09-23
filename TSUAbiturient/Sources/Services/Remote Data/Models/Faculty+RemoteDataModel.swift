//
//  Faculty+RemoteDataModel.swift
//  TSUAbiturient
//

import Foundation
import FirebaseFirestore

extension Faculty: RemoteDataModel {
  static var path: String {
    "Faculties"
  }
  
  init(remoteData: [String: Any], loadNestedEntities: Bool) async throws {
    guard let id = remoteData["id"] as? Int,
          let name = remoteData["name"] as? String,
          let icon = remoteData["icon"] as? String,
          let preview = remoteData["preview"] as? String,
          let sloganColorHEX = remoteData["sloganColor"] as? String,
          let sloganPosition = Faculty.SloganPosition(rawValue: (remoteData["sloganPosition"] as? String) ?? ""),
          let description = remoteData["description"] as? String else {
      throw RemoteDataError.failedToDecodeData
    }
    
    let slogan = (remoteData["slogan"] as? [String]) ?? []
    let pictures = (remoteData["pictures"] as? [String]) ?? []
    let buildingReferences = (remoteData["locations"] as? [DocumentReference]) ?? []
    
    let buildings: [Building]
    
    if loadNestedEntities {
      buildings = try await buildingReferences.asyncMap { reference in
        let document = try await reference.getDocument()
        return try? await Building(remoteData: document.data() ?? [:], loadNestedEntities: true)
      }.compactMap { $0 }
    } else {
      buildings = []
    }
    
    self.init(id: id,
              name: name,
              icon: icon,
              preview: preview,
              slogan: slogan,
              sloganColorHEX: sloganColorHEX,
              sloganPosition: sloganPosition,
              pictures: pictures,
              description: description,
              buildings: buildings)
  }
}

extension Sequence {
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
      var values: [T] = []

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
