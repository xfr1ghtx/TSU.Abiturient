//
//  NetworkService+News.swift
//  TSUAbiturient
//

import Foundation

extension NetworkService: NewsNetworkProtocol {
  private enum Keys {
    static let limit = "limit"
    static let sinceTime = "time"
    
    static let id = "id"
  }
  
  func getNews(limit: Int, since time: TimeInterval) async throws -> [News] {
    let parameters: [String: Any] = [
      Keys.limit: limit,
      Keys.sinceTime: time
    ]
    
    return try await request(method: .get, url: URLFactory.News.news, parameters: parameters)
  }
  
  func getNews(withID id: Int) async throws -> NewsDetails {
    let parameters: [String: Any] = [
      Keys.id: id
    ]
    
    return try await request(method: .get, url: URLFactory.News.news, parameters: parameters)
  }
}
