//
//  NewsCellViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol NewsCellViewModelDelegate: AnyObject {
  func newsCellViewModel(_ viewModel: NewsCellViewModel, didSelect news: News)
}

final class NewsCellViewModel {
  // MARK: - Properties
  
  var previewImageURL: URL? {
    return news.photoURL
  }
  
  var title: String {
    return news.name
  }
  
  var date: String {
    return news.time.formattedDate()
  }
  
  weak var delegate: NewsCellViewModelDelegate?
  
  private let news: News
  
  // MARK: - Init
  
  init(news: News) {
    self.news = news
  }
  
  // MARK: - Public methods
  
  func select() {
    delegate?.newsCellViewModel(self, didSelect: news)
  }
}

// MARK: - TableCellViewModel
extension NewsCellViewModel: TableCellViewModel {
  var tableReuseIdentifier: String {
    NewsCell.reuseIdentifier
  }
}

// MARK: - Equatable
extension NewsCellViewModel: Equatable {
  static func == (lhs: NewsCellViewModel, rhs: NewsCellViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

// MARK: - Hashable

extension NewsCellViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(news)
  }
}
