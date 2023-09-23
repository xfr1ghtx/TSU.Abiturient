//
//  NewsListSections.swift
//  TSUAbiturient
//

import Foundation

enum NewsListSections: Int, Hashable {
  case news = 0
  
  var sectionViewTitle: String {
    switch self {
    case .news:
      return Localizable.NewsTable.title
    }
  }
}
