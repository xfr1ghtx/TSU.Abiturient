//
//  EmptyStateErrorViewDisplaying.swift
//  TSUAbiturient
//

import UIKit

protocol EmptyStateErrorViewDisplaying: AnyObject {
  var emptyStateErrorView: EmptyStateErrorView { get }
  var emptyStateErrorViewContainer: UIView { get }
  
  func setupEmptyStateErrorView()
}

extension EmptyStateErrorViewDisplaying {
  func setupEmptyStateErrorView() {
    emptyStateErrorViewContainer.addSubview(emptyStateErrorView)
    emptyStateErrorView.isHidden = true
    emptyStateErrorView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.centerY.equalToSuperview()
    }
    
    emptyStateErrorView.onDidTapRefreshButton = { [weak self] in
      (self as? ErrorHandling)?.handleRefreshButtonTapped()
    }
  }
}

extension EmptyStateErrorViewDisplaying where Self: UIViewController {
  var emptyStateErrorViewContainer: UIView {
    view
  }
}

extension EmptyStateErrorViewDisplaying where Self: UIView {
  var emptyStateErrorViewContainer: UIView {
    self
  }
}
