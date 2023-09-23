//
//  CalculatorViewController.swift
//  TSUAbiturient
//

import UIKit

final class CalculatorViewController: BaseViewController, TabBarHiding,
                                                          DataLoadingView, ActivityIndicatorViewDisplaying,
                                                          ErrorHandling {
  // MARK: - Properties

  var activityIndicatorView = UIActivityIndicatorView()
  var activityIndicatorContainerView = UIView()
  
  private let dataSource: DirectionListDataSource
  private let viewModel: CalculatorViewModel
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let headerView = CalculatorHeader()
  
  // MARK: - Init
  
  init(viewModel: CalculatorViewModel) {
    self.viewModel = viewModel
    self.dataSource = DirectionListDataSource(tableView: tableView, viewModel: viewModel, headerView: headerView)
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind(to: viewModel)
    viewModel.loadDirectionData()
  }
  
  // MARK: - Public methods
  
  func handleRequestStarted() {
    activityIndicatorContainerView.isHidden = false
    activityIndicatorView.startAnimating()
  }
  
  func handleRequestFinished() {
    activityIndicatorContainerView.isHidden = true
    activityIndicatorView.stopAnimating()
  }
  
  func reloadData() {
    dataSource.reload(animated: false)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupTableView()
    setupActivityIndicatorContainerView()
    setupActivityIndicatorView()
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.backgroundColor = .clear
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false

    tableView.register(CalculatorHeader.self, forHeaderFooterViewReuseIdentifier: CalculatorHeader.reuseIdentifier)
    tableView.register(DirectionCell.self, forCellReuseIdentifier: DirectionCell.reuseIdentifier)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    viewModel.onDidReloadTable = { [weak self] in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    
    
  }

  private func setupActivityIndicatorContainerView() {
    view.addSubview(activityIndicatorContainerView)
    activityIndicatorContainerView.backgroundColor = .white
    activityIndicatorContainerView.isHidden = true
    
    activityIndicatorContainerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    viewModel.onDidUpdateLoaderConstraints = { [weak self] headerHeight in
      self?.viewModel.onScrollDidUpdate = { [weak self] isEnabledScroll in
        self?.tableView.isScrollEnabled = isEnabledScroll
      }
      
      self?.activityIndicatorContainerView.snp.updateConstraints { make in
        make.top.equalToSuperview().inset(headerHeight)
      }
    }
  }
}
