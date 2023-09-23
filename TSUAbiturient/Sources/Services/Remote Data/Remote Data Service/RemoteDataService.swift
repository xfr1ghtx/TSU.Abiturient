//
//  RemoteDataService.swift
//  TSUAbiturient
//

import Foundation
import FirebaseFirestore

class RemoteDataService {
  private let dataBase: Firestore
  
  init() {
    dataBase = Firestore.firestore()
  }
  
  func getCollection<T: RemoteDataModel>(type: T.Type, path: String? = nil, loadNestedEntities: Bool) async throws -> [T] {
    let snapshot = try await dataBase.collection(path ?? type.path).getDocuments()
    return try await snapshot.documents.asyncMap { document in
      return try await T(remoteData: document.data(), loadNestedEntities: loadNestedEntities)
    }
  }
  
  func getDocument<T: RemoteDataModel>(type: T.Type, field: String, value: Any, loadNestedEntities: Bool) async throws -> T? {
    let snapshot = try await dataBase.collection(type.path).whereField(field, isEqualTo: value).getDocuments()
    return try await T(remoteData: snapshot.documents.first?.data() ?? [:], loadNestedEntities: loadNestedEntities)
  }
}
