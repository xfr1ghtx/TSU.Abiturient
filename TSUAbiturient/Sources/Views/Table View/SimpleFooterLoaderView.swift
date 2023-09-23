//
//  SimpleFooterLoaderView.swift
//  TSUAbiturient
//

import UIKit

final class SimpleFooterLoaderView: UIView {
  // MARK: - Properties
  
  let activityIndicator = UIActivityIndicatorView(style: .medium)
  
  private let topPadding: CGFloat
  
  // MARK: - Init
  
  init(withTop padding: CGFloat = .zero) {
    topPadding = padding
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("SimpleFooterLoaderView init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Public methods
  
  func startAnimating() {
    activityIndicator.startAnimating()
  }
  
  func stopAnimating() {
    activityIndicator.stopAnimating()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupActivityIndicator()
  }
  
  private func setupContainer() {
    backgroundColor = .clear
  }
  
  private func setupActivityIndicator() {
    addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.size.equalTo(24)
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(topPadding)
    }
  }
}
