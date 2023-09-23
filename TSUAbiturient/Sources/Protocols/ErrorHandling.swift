//
//  ErrorHandling.swift
//  TSUAbiturient
//

import UIKit

protocol ErrorHandling: BannerShowing {
  func handle(_ error: Error)
  func handle(_ error: Error, showAsEmptyState: Bool)
  func handleRefreshButtonTapped()
}

extension ErrorHandling {
  func handle(_ error: Error) {
    handle(error, showAsEmptyState: true)
  }
  
  func handle(_ error: Error, showAsEmptyState: Bool) {
    if showAsEmptyState, let self = self as? EmptyStateErrorViewDisplaying {
      self.emptyStateErrorView.isHidden = false
      if NetworkServiceErrorUtility.isNoInternetError(error) {
        self.emptyStateErrorView.configure(for: .noInternet)
      } else {
        self.emptyStateErrorView.configure(for: .serverError)
      }
    } else {
      showBanner(title: Localizable.Common.done,
                 subtitle: error.localizedDescription, style: .danger)
    }
  }
  
  func handleRefreshButtonTapped() {
    // Do nothing
  }
}
