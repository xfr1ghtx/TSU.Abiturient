//
//  AuthViewController.swift
//  TSUAbiturient
//

import UIKit
import WebKit

final class AuthViewController: BaseViewController {
  // MARK: - Properties
  
  private let viewModel: AuthViewModel
  private let authPageURL: URL
  
  private let webView = WKWebView()
  
  // MARK: - Inits
  
  init(viewModel: AuthViewModel, authPageURL: URL) {
    self.viewModel = viewModel
    self.authPageURL = authPageURL
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    view.addSubview(webView)
    webView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    webView.navigationDelegate = self
    webView.load(NSURLRequest(url: authPageURL) as URLRequest)
  }
}

extension AuthViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
    guard let url = navigationAction.request.url else { return .cancel }
    return viewModel.initialLoadRedirectTo(URL: url)
  }
}
