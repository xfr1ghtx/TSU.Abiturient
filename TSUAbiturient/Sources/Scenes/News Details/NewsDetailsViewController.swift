//
//  NewsDetailsViewController.swift
//  TSUAbiturient
//

import UIKit
import WebKit
import SnapKit

private extension Constants {
   static let headerHeight: CGFloat = 283
}

final class NewsDetailsViewController: BaseViewController, NavigationBarHiding,
                                       DataLoadingView, ActivityIndicatorViewDisplaying, ErrorHandling {
   // MARK: - Properties
   
   let activityIndicatorView = UIActivityIndicatorView()
   let activityIndicatorContainerView = UIView()
   
   private let headerImageView = UIImageView()
   private let backButton = UIButton()
   private let scrollView = UIScrollView()
   private let scrollContentView = UIView()
   private let labelStackViewContainer = UIStackView()
   private let contentStackViewContainer = UIStackView()
   private let tagsView = TagListView()
   private let titleLabel = Label(textStyle: .header3)
   private let dateLabel = Label(textStyle: .footnote)
   private let photosView = PhotoCarouselView()
   private let containerPhotosView = UIView()
   private let textWebView = WKWebView()
   private let darkGradientView = UIView()
   private let lightGradientView = UIView()
   
   private lazy var darkGradientLayer: CAGradientLayer = {
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [UIColor.Gradient.blackFullTransparent.cgColor, UIColor.Gradient.blackTransparent.cgColor]
      gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
      gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
      
      return gradientLayer
   }()
   
   private lazy var lightGradientLayer: CAGradientLayer = {
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [UIColor.Gradient.white.cgColor, UIColor.Gradient.whiteTransparent.cgColor]
      gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
      gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
      
      return gradientLayer
   }()
   
   private var textWebViewHeight: Constraint?
   private var headerHeightConstraint: Constraint?
   
   private var oldContentOffset: CGFloat = -259
   
   private let viewModel: NewsDetailsViewModel
   
   // MARK: - Inits
   
   init(viewModel: NewsDetailsViewModel) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("NewsDetailsViewController init(coder:) has not been implemented")
   }
   
   // MARK: - Lifecycle methods
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setup()
      bind(to: viewModel)
      viewModel.loadData()
   }
   
   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      darkGradientLayer.frame = darkGradientView.bounds
      lightGradientLayer.frame = lightGradientView.bounds
   }
   
   // MARK: - Public methods
   
   func handleRequestStarted() {
      activityIndicatorContainerView.isHidden = false
   }
   
   func reloadData() {
      guard let news = viewModel.newsDetails else { return }
      self.tagsView.configure(with: news.tags)
      self.titleLabel.text = news.name
      self.dateLabel.text = news.time.formattedDate()
      if news.photosURLs.isEmpty == false {
         self.photosView.configure(withURLs: news.photosURLs)
      } else {
         self.containerPhotosView.isHidden = true
      }
      self.textWebView.loadHTMLString(news.preparedText, baseURL: nil)
   }
   
   // MARK: - Actions
   
   @objc
   private func handleBackButton() {
      self.navigationController?.popViewController(animated: true)
   }
   
   // MARK: - Setup
   
   private func setup() {
      setupHeaderImageView()
      setupDarkGradientView()
      setupScrollView()
      setupLightGradientView()
      setupTagsView()
      setupStackViewContainer()
      setupTitleLabel()
      setupDateLabel()
      setupContentStackViewContainer()
      setupPhotosView()
      setupTextWebView()
      setupActivityIndicatorContainerView()
      setupActivityIndicatorView()
      setupBackButton()
   }
   
   private func setupBackButton() {
      view.addSubview(backButton)
      backButton.layer.cornerCurve = .continuous
      backButton.layer.cornerRadius = 16
      backButton.backgroundColor = .Gradient.blackTransparent
      backButton.tintColor = .Light.Icons.white
      backButton.setImage(Assets.Images.chevronLeft.image.withRenderingMode(.alwaysTemplate), for: .normal)
      backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
      backButton.snp.makeConstraints { make in
         make.size.equalTo(32)
         make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
         make.leading.equalToSuperview().offset(16)
      }
   }
   
   private func setupHeaderImageView() {
      view.addSubview(headerImageView)
      headerImageView.setImage(with: viewModel.news.photoURL, placeholder: nil, options: [.backgroundDecode])
      headerImageView.contentMode = .scaleAspectFill
      headerImageView.layer.masksToBounds = true
      headerImageView.snp.makeConstraints { make in
         make.top.equalToSuperview()
         make.horizontalEdges.equalToSuperview()
         headerHeightConstraint = make.height.equalTo(Constants.headerHeight).constraint
      }
   }
   
   private func setupDarkGradientView() {
      view.addSubview(darkGradientView)
      darkGradientView.clipsToBounds = true
      darkGradientView.layer.insertSublayer(darkGradientLayer, at: 0)
      darkGradientView.snp.makeConstraints { make in
         make.bottom.equalTo(headerImageView.snp.bottom)
         make.height.equalTo(Constants.headerHeight)
         make.horizontalEdges.equalToSuperview()
      }
   }
   
   private func setupScrollView() {
      view.addSubview(scrollView)
      
      scrollView.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
      
      scrollView.contentInsetAdjustmentBehavior = .never
      scrollView.contentInset.top = Constants.headerHeight - 24
      scrollView.addSubview(scrollContentView)
      scrollView.backgroundColor = .clear
      scrollView.showsVerticalScrollIndicator = false
      scrollView.delegate = self
      
      scrollContentView.layer.cornerRadius = 24
      scrollContentView.layer.cornerCurve = .continuous
      scrollContentView.backgroundColor = .Light.Surface.primary
      scrollContentView.layer.masksToBounds = true
      
      scrollContentView.snp.makeConstraints { make in
         make.edges.equalToSuperview()
         make.width.equalToSuperview()
      }
   }
   
   private func setupLightGradientView() {
      view.addSubview(lightGradientView)
      lightGradientView.clipsToBounds = true
      lightGradientView.layer.insertSublayer(lightGradientLayer, at: 0)
      lightGradientView.layer.opacity = 0
      lightGradientView.snp.makeConstraints { make in
         make.height.equalTo(60)
         make.horizontalEdges.equalToSuperview()
         make.top.equalTo(view.safeAreaInsets)
      }
   }
   
   private func setupTagsView() {
      scrollContentView.addSubview(tagsView)
      tagsView.snp.makeConstraints { make in
         make.horizontalEdges.equalToSuperview()
         make.top.equalToSuperview().offset(24)
         make.height.equalTo(24)
      }
   }
   
   private func setupStackViewContainer() {
      scrollContentView.addSubview(labelStackViewContainer)
      labelStackViewContainer.spacing = 16
      labelStackViewContainer.backgroundColor = .clear
      labelStackViewContainer.axis = .vertical
      labelStackViewContainer.alignment = .fill
      labelStackViewContainer.distribution = .fill
      labelStackViewContainer.snp.makeConstraints { make in
         make.top.equalTo(tagsView.snp.bottom).offset(16)
         make.leading.trailing.equalToSuperview().inset(24)
      }
   }
   
   private func setupTitleLabel() {
      labelStackViewContainer.addArrangedSubview(titleLabel)
      titleLabel.textColor = .Light.Text.primary
      titleLabel.numberOfLines = 0
      labelStackViewContainer.setCustomSpacing(8, after: titleLabel)
   }
   
   private func setupDateLabel() {
      labelStackViewContainer.addArrangedSubview(dateLabel)
      dateLabel.textColor = .Light.Text.secondary
   }
   
   private func setupContentStackViewContainer() {
      scrollContentView.addSubview(contentStackViewContainer)
      contentStackViewContainer.backgroundColor = .clear
      contentStackViewContainer.axis = .vertical
      contentStackViewContainer.alignment = .fill
      contentStackViewContainer.distribution = .fill
      contentStackViewContainer.snp.makeConstraints { make in
         make.top.equalTo(labelStackViewContainer.snp.bottom)
         make.leading.trailing.equalToSuperview()
      }
   }
   
   private func setupPhotosView() {
      containerPhotosView.addSubview(photosView)
      photosView.itemSize = CGSize(width: view.bounds.width - 48, height: 200)
      photosView.snp.makeConstraints { make in
         make.leading.trailing.bottom.equalToSuperview()
         make.top.equalToSuperview().offset(16)
         make.height.equalTo(200)
      }
      contentStackViewContainer.addArrangedSubview(containerPhotosView)
   }
   
   private func setupTextWebView() {
      scrollContentView.addSubview(textWebView)
      textWebView.navigationDelegate = self
      textWebView.scrollView.showsVerticalScrollIndicator = false
      textWebView.scrollView.contentInsetAdjustmentBehavior = .never
      textWebView.scrollView.bounces = false
      textWebView.contentMode = .scaleToFill
      textWebView.snp.makeConstraints { make in
         make.top.equalTo(contentStackViewContainer.snp.bottom).offset(24)
         make.leading.trailing.equalToSuperview().inset(24)
         make.bottom.equalToSuperview().inset(34)
         textWebViewHeight = make.height.equalTo(100).constraint
      }
   }
   
   private func setupActivityIndicatorContainerView() {
      view.addSubview(activityIndicatorContainerView)
      activityIndicatorContainerView.backgroundColor = .white
      activityIndicatorContainerView.isHidden = true
      
      activityIndicatorContainerView.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
   }
}

// MARK: - UIScrollViewDelegate

extension NewsDetailsViewController: UIScrollViewDelegate {
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let diff = oldContentOffset - scrollView.contentOffset.y
      
      guard diff != 0 else { return }
      if scrollView.contentOffset.y < 24 {
         headerHeightConstraint?.update(offset: -scrollView.contentOffset.y + 24)
      } else {
         headerHeightConstraint?.update(offset: 0)
      }
      
      if scrollView.contentOffset.y <= 0 && lightGradientView.layer.opacity == 1 {
         UIView.animate(withDuration: 0.3) { [weak self] in
            self?.lightGradientView.layer.opacity = 0
         }
      } else if scrollView.contentOffset.y > 0 && lightGradientView.layer.opacity != 1 {
         UIView.animate(withDuration: 0.3) { [weak self] in
            self?.lightGradientView.layer.opacity = 1
         }
      }
      
      headerImageView.layoutIfNeeded()
      oldContentOffset = scrollView.contentOffset.y
   }
}

// MARK: - WKNavigationDelegate

extension NewsDetailsViewController: WKNavigationDelegate {
   func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      // asyncAfter необходим, чтобы все работало, без него не работает.
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
         self?.textWebViewHeight?.update(offset: webView.scrollView.contentSize.height)
         self?.activityIndicatorView.stopAnimating()
         self?.activityIndicatorContainerView.isHidden = true
      }
   }
   
   func webView(_ webView: WKWebView,
                decidePolicyFor navigationAction: WKNavigationAction,
                decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      guard let url = navigationAction.request.url, url.absoluteString != "about:blank" else {
         decisionHandler(.allow)
         return
      }
      UIApplication.shared.open(url)
      decisionHandler(.cancel)
      return
   }
}
