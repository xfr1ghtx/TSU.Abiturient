//
//  MainViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
  func mainViewModel(_ viewModel: MainViewModel, didRequestToShow news: News)
  func mainViewModel(_ viewModel: MainViewModel, didRequestToShow event: Event)
  func mainViewModel(_ viewModel: MainViewModel, didRequestToShow events: [Event])
  func mainViewModelDidRequestToShowAuth(_ viewModel: MainViewModel)
}

final class MainViewModel: DataLoadingViewModel {
  typealias Dependencies = HasNewsService & HasEventsService &
  HasDataStore & HasUserService & HasEducationProgramsService & HasOAuthService
  
  // MARK: - Properties
  
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  
  var onDidStartUpdateData: (() -> Void)?
  var onDidFinishUpdateData: (() -> Void)?
  
  var onDidShowEvents: (() -> Void)?
  
  weak var delegate: MainViewModelDelegate?
  
  private let dependencies: Dependencies
  
  private(set) var upcommingEventsViewModel: UpcommingEventsViewModel
  private(set) var profileViewModel: ProfileViewModel
  
  private(set) var tableItems: [NewsListSections: [NewsCellViewModel]] = [:]
  private var lastNewsTime = Date().timeIntervalSince1970
  private var firstLoad = true
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    self.upcommingEventsViewModel = UpcommingEventsViewModel(dependencies: dependencies)
    self.profileViewModel = ProfileViewModel(dependencies: dependencies)
    upcommingEventsViewModel.delegate = self
    profileViewModel.delegate = self
  }
  
  // MARK: - Public methods
  
  func loadData() {
    loadProfile()
    loadNews()
  }
  
  private func loadProfile() {}
  
  private func loadNews() {
    if firstLoad {
      onDidStartRequest?()
    } else {
      onDidStartUpdateData?()
    }
    Task {
      do {
        let news = try await dependencies.newsService.getNews(limit: Constants.newsLimitDownload, since: lastNewsTime)
        await MainActor.run {
          handleNews(news)
        }
      } catch let error {
        await MainActor.run {
          onDidReceiveError?(error)
          if firstLoad {
            onDidFinishRequest?()
          } else {
            onDidFinishUpdateData?()
          }
        }
      }
    }
  }
  
  // MARK: - Private methods
  
  private func handleNews(_ news: [News]) {
    let viewModels = news.map { NewsCellViewModel(news: $0) }
    
    viewModels.forEach { viewModel in
      viewModel.delegate = self
    }
    
    if tableItems[.news] != nil {
      tableItems[.news]?.append(contentsOf: viewModels)
    } else {
      tableItems[.news] = viewModels
    }
    
    if firstLoad {
      onDidFinishRequest?()
    } else {
      onDidFinishUpdateData?()
    }
    
    if let lastNewsTime = news.last?.time {
      self.lastNewsTime = lastNewsTime
      firstLoad = false
    }
    
    onDidLoadData?()
  }
}

// MARK: - NewsCellViewModelDelegate

extension MainViewModel: NewsCellViewModelDelegate {
  func newsCellViewModel(_ viewModel: NewsCellViewModel, didSelect news: News) {
    delegate?.mainViewModel(self, didRequestToShow: news)
  }
}

// MARK: - UpcommingEventsViewModelDelegate

extension MainViewModel: UpcommingEventsViewModelDelegate {
  func upcommingEventsViewModel(_ upcommingEventsViewModel: UpcommingEventsViewModel, didRequestToShow events: [Event]) {
    delegate?.mainViewModel(self, didRequestToShow: events)
  }
  
  func upcommingEventsViewModel(_ upcommingEventsViewModel: UpcommingEventsViewModel, didRequestToShow event: Event) {
    delegate?.mainViewModel(self, didRequestToShow: event)
  }
  
  func upcommingEventsViewModelDidRequestToShowView(_ upcommingEventsViewModel: UpcommingEventsViewModel) {
    onDidShowEvents?()
  }
}

// MARK: - ProfileViewModelDelegate

extension MainViewModel: ProfileViewModelDelegate {
  func profileViewModelDidRequestToShowAuth(_ profileViewModel: ProfileViewModel) {
    delegate?.mainViewModelDidRequestToShowAuth(self)
  }
}
