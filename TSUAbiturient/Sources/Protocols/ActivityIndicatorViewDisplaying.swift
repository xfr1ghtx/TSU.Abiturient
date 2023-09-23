//
//  ActivityIndicatorViewDisplaying.swift
//  TSUAbiturient
//

import UIKit

protocol ActivityIndicatorViewDisplaying {
  // TODO: Добавить кастомный лоудер
  
  var activityIndicatorView: UIActivityIndicatorView { get }
  var activityIndicatorContainerView: UIView { get }
  
  func setupActivityIndicatorView()
}

extension ActivityIndicatorViewDisplaying {
  func setupActivityIndicatorView() {
    activityIndicatorContainerView.addSubview(activityIndicatorView)
    activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}

extension ActivityIndicatorViewDisplaying where Self: UIViewController {
  var activityIndicatorContainerView: UIView {
    view
  }
}

extension ActivityIndicatorViewDisplaying where Self: UIView {
  var activityIndicatorContainerView: UIView {
    self
  }
}
