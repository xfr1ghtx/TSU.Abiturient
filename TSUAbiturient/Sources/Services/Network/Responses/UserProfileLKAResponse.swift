//
//  UserProfileLKAResponse.swift
//  TSUAbiturient
//

import Foundation

struct UserProfileLKAResponse: Codable {
  let success: Bool
  let data: UserProfileLKA
  let message: String
}

struct UserProfileLKA: Codable {
  let TSUAccountID: String
  let firstName: String
  let lastName: String
  let patronymic: String
  let request: LKARequest
  
  enum CodingKeys: String, CodingKey {
    case TSUAccountID = "tsuAccountId"
    case firstName, lastName, patronymic, request
  }
}

struct LKARequest: Codable {
  let selectedDirections: [EducationProgram]
  let id: String
}

struct EducationProgram: Codable {
  let priority: Int
  let educationProgram: EducationProgramInfo
  let educationBase: EducationBase
  
  enum CodingKeys: String, CodingKey {
    case priority, educationProgram, educationBase
  }
}

struct EducationProgramInfo: Codable {
  let curriculumID: String
  let profile: ProfileResponse
  let faculty: FacultyResponse
  let speciality: SpecialityResponse
  
  enum CodingKeys: String, CodingKey {
    case profile, faculty, speciality
    case curriculumID = "curriculumId"
  }
}

struct ProfileResponse: Codable {
  let name: String
  let speciality: SpecialityResponse
}

struct FacultyResponse: Codable {
  let name: String
}

struct SpecialityResponse: Codable {
  let name: String
}
