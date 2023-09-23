//
//  EventsViewController.swift
//  TSUAbiturient
//

import UIKit

private extension Constants {
  static let bottomContentInset: CGFloat = 24
}

final class EventsViewController: BaseViewController {
  // MARK: - Properties
  
  private let viewModel: EventsViewModel
  private let tableView = UITableView()
  
  private let dataSource: EventsDataSource
  
  // MARK: - Init
  
  init(viewModel: EventsViewModel) {
    self.viewModel = viewModel
    self.dataSource = EventsDataSource(tableView: tableView, viewModel: viewModel)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("EventsViewController init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    dataSource.reload(animated: false)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupTableView()
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.backgroundColor = .clear
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.bounces = false
    tableView.contentInset.bottom = Constants.bottomContentInset
    tableView.register(EventCardCell.self, forCellReuseIdentifier: EventCardCell.reuseIdentifier)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
