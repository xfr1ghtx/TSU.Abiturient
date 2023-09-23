//
//  NewsDetailsViewModel.swift
//  TSUAbiturient
//

import Foundation

final class NewsDetailsViewModel: DataLoadingViewModel {
  typealias Dependencies = HasNewsService
  
  // MARK: - Properties
  
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  
  private(set) var newsDetails: NewsDetails?
  private(set) var news: News
  
  private let dependencies: Dependencies
  
  // MARK: - Init
  
  init(news: News, dependencies: Dependencies) {
    self.news = news
    self.dependencies = dependencies
  }
  
  // MARK: - Public methods
  
  func loadData() {
    onDidStartRequest?()
    Task {
      do {
        let newsDetails = try await dependencies.newsService.getNews(withID: news.id)
        await MainActor.run {
          handleNews(newsDetails)
        }
      } catch let error {
        await MainActor.run {
          onDidReceiveError?(error)
        }
      }
    }
  }
  
  // MARK: - Private methods
  
  private func handleNews(_ newsDetails: NewsDetails) {
    self.newsDetails = newsDetails
    onDidLoadData?()
    onDidFinishRequest?()
  }
}
