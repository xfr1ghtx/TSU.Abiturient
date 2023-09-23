//
//  NewsListDataSource.swift
//  TSUAbiturient
//

import UIKit

final class NewsListDataSource: UITableViewDiffableDataSource<NewsListSections, NewsCellViewModel> {
  // MARK: - Properties
  
  private let tableView: UITableView
  private let viewModel: MainViewModel
  
  // MARK: - Init
  
  init(tableView: UITableView, viewModel: MainViewModel) {
    self.tableView = tableView
    self.viewModel = viewModel
    
    super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell else {
        return UITableViewCell()
      }
      cell.configure(with: itemIdentifier)
      return cell
    }
    
    tableView.delegate = self
  }
  
  // MARK: - Methods
  
  func reload(animated: Bool = true) {
    var snapshot = snapshot()
    snapshot.deleteAllItems()
    
    let sections: [NewsListSections] = viewModel.tableItems.compactMap { $0.key }
    snapshot.appendSections(sections)
    
    sections.forEach { section in
      if let items = viewModel.tableItems[section] {
        snapshot.appendItems(items, toSection: section)
      }
    }

    apply(snapshot, animatingDifferences: animated)
  }
}

// MARK: - UITableViewDelegate

extension NewsListDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let section = NewsListSections(rawValue: section) else { return nil }
    let viewModel = SimpleSectionHeaderViewModel(title: section.sectionViewTitle)
    let view = SimpleSectionHeader()
    view.configure(with: viewModel)
    return view
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = NewsListSections(rawValue: indexPath.section) else { return }
    viewModel.tableItems[section]?.element(at: indexPath.row)?.select()
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let section = NewsListSections(rawValue: indexPath.section),
    let count = viewModel.tableItems[section]?.count else { return }
    if indexPath.row == count - 6 {
      viewModel.loadData()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    UITableView.automaticDimension
  }
}
