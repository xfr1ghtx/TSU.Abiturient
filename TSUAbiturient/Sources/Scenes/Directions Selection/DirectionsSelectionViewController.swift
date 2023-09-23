//
//  DirectionsSelectionViewController.swift
//  TSUAbiturient
//

import UIKit

class DirectionsSelectionViewController: BaseViewController, TabBarHiding,
                                                             DataLoadingView, ActivityIndicatorViewDisplaying,
                                                             ErrorHandling {
  // MARK: - Properties
  
  var activityIndicatorView = UIActivityIndicatorView()
  var activityIndicatorContainerView = UIView()
  
  private let viewModel: DirectionsSelectionViewModel
  private let dataSource: DisciplinesListDataSource
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let headerView = DirectionsSelectionHeader()
  
  // MARK: - Init
  
  init(viewModel: DirectionsSelectionViewModel) {
    self.viewModel = viewModel
    self.dataSource = DisciplinesListDataSource(tableView: tableView, viewModel: viewModel, headerView: headerView)
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind(to: viewModel)
    viewModel.getDisciplines()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.delegate?.transferViewModelData(viewModel.viewModelItems)
  }
  
  func handleRequestStarted() {
    activityIndicatorContainerView.isHidden = false
    activityIndicatorView.startAnimating()
  }
  
  func handleRequestFinished() {
    activityIndicatorContainerView.isHidden = true
    activityIndicatorView.stopAnimating()
  }
  
  func reloadData() {
    dataSource.saveSnapshot(animated: false)
  }
  
  func updateData() {}
  
  // MARK: - Setup
  
  private func setup() {
    setupTableView()
    setupActivityIndicatorContainerView()
    setupActivityIndicatorView()
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    
    tableView.backgroundColor = .Light.Surface.primary
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.bounces = false
    
    tableView.register(DisciplineCell.self, forCellReuseIdentifier: DisciplineCell.reuseIdentifier)
    tableView.register(DirectionsSelectionHeader.self,
                       forHeaderFooterViewReuseIdentifier: DirectionsSelectionHeader.reuseIdentifier)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupActivityIndicatorContainerView() {
    view.addSubview(activityIndicatorContainerView)
    activityIndicatorContainerView.backgroundColor = .clear
    activityIndicatorContainerView.isHidden = false
    
    activityIndicatorContainerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
