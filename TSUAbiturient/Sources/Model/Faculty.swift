//
//  Faculty.swift
//  TSUAbiturient
//

import UIKit

struct Faculty: Codable {
  enum SloganPosition: String, Codable {
    case topLeft = "TOP_LEFT", topRight = "TOP_RIGHT", bottomLeft = "BOTTOM_LEFT", bottomRight = "BOTTOM_RIGHT"
  }
  
  let id: Int
  let name: String
  let icon: String
  let preview: String
  let slogan: [String]
  let sloganColorHEX: String
  let sloganPosition: SloganPosition
  let pictures: [String]
  let description: String
  let buildings: [Building]
  var contacts: [FacultyContact] = []
  var links: [FacultyLink] = []
  
  var iconURL: URL? {
    URL(string: icon)
  }
  
  var previewURL: URL? {
    URL(string: preview)
  }
  
  var sloganColor: UIColor? {
    UIColor(hex: sloganColorHEX)
  }
  
  var pictureURLs: [URL] {
    return pictures.compactMap { URL(string: $0) }
  }
}
