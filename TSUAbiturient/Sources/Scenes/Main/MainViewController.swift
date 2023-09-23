//
//  MainViewController.swift
//  TSUAbiturient
//

import UIKit
import SnapKit

private extension Constants {
  static let bottomContentInset: CGFloat = 68
  static let footerHeight: CGFloat = 50
  static let gradientBackgroundHeight = 331
}

final class MainViewController: BaseViewController, NavigationBarHiding,
                                  DataLoadingView,
                                  ActivityIndicatorViewDisplaying,
                                  ErrorHandling {
  // MARK: - Properties
  
  var activityIndicatorView = UIActivityIndicatorView()
  var activityIndicatorContainerView = UIView()
  
  private let viewModel: MainViewModel
  private let dataSource: NewsListDataSource
  
  private let headerView = UIView()
  private let gradientBackground = GradientBackgroundView()
  private let containerStackView = UIStackView()
  private let profileView = ProfileView()
  private let eventsComponent = UpcommingEventsView()

  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let footerView = SimpleFooterLoaderView()
  
  // MARK: - Init
  
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    self.dataSource = NewsListDataSource(tableView: tableView, viewModel: viewModel)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("MainViewController init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind(to: viewModel)
    bindToViewModel()
    viewModel.loadData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(16 + view.safeAreaInsets.top)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview().inset(16)
    }
  }
  
  // MARK: - Public methods
  
  func handleRequestStarted() {
    activityIndicatorContainerView.isHidden = false
  }
  
  func handleRequestFinished() {
    activityIndicatorContainerView.isHidden = true
  }
  
  func reloadData() {
    dataSource.reload(animated: false)
  }
  
  // MARK: - Bind to ViewModel
  
  private func bindToViewModel() {
    viewModel.onDidStartUpdateData = { [weak self] in
      guard let self = self else { return }
      self.tableView.tableFooterView = self.footerView
    }

    viewModel.onDidFinishUpdateData = { [weak self] in
      guard let self = self else { return }
      self.tableView.tableFooterView = nil
    }
    
    viewModel.onDidShowEvents = { [weak self] in
      guard let self = self else { return }
      self.eventsComponent.isHidden = false
    }
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupGradientBackground()
    setupContainerStackView()
    setupProfileView()
    setupEventsComponent()
    setupHeaderView()
    setupFooterView()
    setupTableView()
    setupActivityIndicatorContainerView()
    setupActivityIndicatorView()
  }
  
  private func setupGradientBackground() {
    headerView.addSubview(gradientBackground)
  }
  
  private func setupContainerStackView() {
    headerView.addSubview(containerStackView)
    containerStackView.axis = .vertical
    containerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    containerStackView.isLayoutMarginsRelativeArrangement = true
    containerStackView.spacing = 24
  }
  
  private func setupProfileView() {
    containerStackView.addArrangedSubview(profileView)
    profileView.configure(with: viewModel.profileViewModel)
    profileView.onDidUpdate = { [weak self] in
      let headerView = self?.tableView.tableHeaderView ?? UIView()

      headerView.setNeedsLayout()
      headerView.layoutIfNeeded()

      let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
      var frame = headerView.frame
      frame.size.height = height
      headerView.frame = frame

      self?.tableView.tableHeaderView = headerView
      self?.tableView.layoutIfNeeded()
    }
    gradientBackground.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(profileView.snp.bottom).offset(35).priority(500)
      make.height.lessThanOrEqualTo(280)
    }
  }
  
  private func setupEventsComponent() {
    containerStackView.addArrangedSubview(eventsComponent)
    eventsComponent.isHidden = true
    eventsComponent.configure(with: viewModel.upcommingEventsViewModel)
  }

  private func setupHeaderView() {
    tableView.tableHeaderView = headerView
    headerView.snp.makeConstraints { make in
      make.centerX.equalTo(tableView.snp.centerX)
      make.width.equalTo(tableView.snp.width)
      make.top.equalTo(tableView.snp.top)
    }
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.backgroundColor = .clear
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.bounces = false
    tableView.contentInset.bottom = Constants.bottomContentInset
    tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    tableView.register(SimpleSectionHeader.self, forHeaderFooterViewReuseIdentifier: SimpleSectionHeader.reuseIdentifier)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
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
  
  private func setupFooterView() {
    footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: Constants.footerHeight)
    footerView.startAnimating()
  }
}
