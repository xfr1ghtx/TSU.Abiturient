//
//  FacultiesViewController.swift
//  TSUAbiturient
//

import UIKit

class FacultiesViewController: UITableViewController, DataLoadingView, ActivityIndicatorViewDisplaying, ErrorHandling {
  let activityIndicatorView = UIActivityIndicatorView()
  
  private let dataSource = TableViewDiffableDataSource<FacultyCardCell, DefaultTableSection, FacultyCardViewModel>()
  
  private let viewModel: FacultiesViewModel
  
  init(viewModel: FacultiesViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind(to: viewModel)
    viewModel.loadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationItem.hidesSearchBarWhenScrolling = true
  }
  
  func reloadData() {
    var snapshot = dataSource.createSnapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(viewModel.cellViewModels, toSection: .main)
    dataSource.apply(snapshot)
  }
  
  private func setup() {
    setupTableView()
    setupActivityIndicatorView()
  }
  
  private func setupTableView() {
    tableView.backgroundColor = UIColor.Light.Background.primary
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 264
    tableView.rowHeight = UITableView.automaticDimension
    tableView.showsVerticalScrollIndicator = false
    tableView.contentInset.bottom = 12
    tableView.contentInset.top = 4
    
    dataSource.setup(tableView: tableView)
    dataSource.delegate = self
  }
}

// MARK: - TableViewDiffableDataSourceDelegate

extension FacultiesViewController: TableViewDiffableDataSourceDelegate {
  func tableViewDiffableDataSource(didSelectItemAt indexPath: IndexPath) {
    viewModel.select(index: indexPath.row)
  }
}
