//
//  News.swift
//  TSUAbiturient
//

import Foundation

struct News: Codable, Hashable {
  let id: Int
  let name: String
  let description: String
  let time: TimeInterval
  let photoStringURL: String
  
  var photoURL: URL? {
    return URL(string: photoStringURL)
  }
  
  enum CodingKeys: String, CodingKey {
    case id, name, description, time, photoStringURL = "photo"
  }
}
