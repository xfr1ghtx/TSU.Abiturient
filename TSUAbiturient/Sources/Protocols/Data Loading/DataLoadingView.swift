//
//  DataLoadingView.swift
//  TSUAbiturient
//

import Foundation

protocol DataLoadingView: AnyObject {
  func bind(to viewModel: DataLoadingViewModel)
  func handleRequestStarted()
  func handleRequestFinished()
  func handleErrorReceived()
  func reloadData()
}

extension DataLoadingView where Self: ActivityIndicatorViewDisplaying & ErrorHandling {
  func bind(to viewModel: DataLoadingViewModel) {
    viewModel.onDidStartRequest = { [weak self] in
      DispatchQueue.main.async {
        (self as? EmptyStateErrorViewDisplaying)?.emptyStateErrorView.isHidden = true
        self?.activityIndicatorView.isHidden = false
        self?.activityIndicatorView.startAnimating()
      }
      self?.handleRequestStarted()
    }
    
    viewModel.onDidFinishRequest = { [weak self] in
      DispatchQueue.main.async {
        self?.activityIndicatorView.isHidden = true
        self?.activityIndicatorView.stopAnimating()
      }
      self?.handleRequestFinished()
    }
    
    viewModel.onDidLoadData = { [weak self] in
      self?.reloadData()
    }
    
    viewModel.onDidReceiveError = { [weak self] error in
      self?.handle(error, showAsEmptyState: true)
      self?.handleErrorReceived()
    }
  }
  
  func handleRequestStarted() {}
  func handleRequestFinished() {}
  func handleErrorReceived() {}
  func reloadData() {}
}
