//
//  RemoteDataService+Faculties.swift
//  TSUAbiturient
//

import Foundation

extension RemoteDataService: FacultiesRemoteDataProtocol {
  func getFaculties() async throws -> [Faculty] {
    return try await getCollection(type: Faculty.self, loadNestedEntities: false)
  }
  
  func getFaculty(id: Int) async throws -> Faculty? {
    let contacts = try await getCollection(type: FacultyContact.self,
                                           path: "\(Faculty.path)/\(id)/\(FacultyContact.path)",
                                           loadNestedEntities: true)
    let links = try await getCollection(type: FacultyLink.self,
                                        path: "\(Faculty.path)/\(id)/\(FacultyLink.path)",
                                        loadNestedEntities: true)
    var faculty = try await getDocument(type: Faculty.self, field: "id", value: id, loadNestedEntities: true)
    faculty?.contacts = contacts
    faculty?.links = links
    return faculty
  }
}
