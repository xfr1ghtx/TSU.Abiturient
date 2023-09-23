//
//  NewsDetails.swift
//  TSUAbiturient
//

import Foundation

struct NewsDetails: Codable {
  let id: Int
  let name: String
  let time: TimeInterval
  let text: String
  let tags: [NewsTag]
  let mainPhotoStringURL: String
  let photosStringURLs: [String]
  
  var mainPhotoURL: URL? {
    return URL(string: mainPhotoStringURL)
  }
  
  var photosURLs: [URL?] {
    return photosStringURLs.map { URL(string: $0) }
  }
  
  var preparedText: String {
    return prepareHTMLText(text)
  }
  
  enum CodingKeys: String, CodingKey {
    case id, name, time, text, tags, mainPhotoStringURL = "mainPhoto", photosStringURLs = "photos"
  }
}
