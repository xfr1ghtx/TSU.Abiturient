//
//  TableViewDataSource.swift
//  TSUAbiturient
//

import UIKit

protocol TableViewDataSourceDelegate: AnyObject {
  func tableViewDataSource(_ dataSource: TableViewDataSource, canEditRowAt indexPath: IndexPath) -> Bool
  func tableViewDataSource(_ dataSource: TableViewDataSource,
                           commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
}

class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  weak var delegate: TableViewDataSourceDelegate?

  var onDidScroll: ((_ scrollView: UIScrollView) -> Void)?

  private var tableView: UITableView?
  private var viewModel: TableViewModel?
  
  func setup(tableView: UITableView, viewModel: TableViewModel) {
    self.tableView = tableView
    self.viewModel = viewModel
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
  }
  
  func update(with viewModel: TableViewModel) {
    self.viewModel = viewModel
    tableView?.reloadData()
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel?.sectionViewModels.count ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.sectionViewModels.element(at: section)?.cellViewModels.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cellViewModel = viewModel?.sectionViewModels.element(at: indexPath.section)?
            .cellViewModels.element(at: indexPath.row) else {
      return UITableViewCell()
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.tableReuseIdentifier,
                                             for: indexPath)
    (cell as? TableCell)?.configure(with: cellViewModel)
    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerViewModel = viewModel?.sectionViewModels.element(at: section)?.headerViewModel else {
      return nil
    }
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewModel.tableReuseIdentifier)
    (headerView as? TableHeaderFooterView)?.configure(with: headerViewModel)
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if viewModel?.sectionViewModels.element(at: section)?.headerViewModel != nil {
      return UITableView.automaticDimension
    }

    return .leastNormalMagnitude
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return nil
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return .leastNormalMagnitude
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel?.sectionViewModels.element(at: indexPath.section)?.cellViewModels.element(at: indexPath.row)?.select()
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return delegate?.tableViewDataSource(self, canEditRowAt: indexPath) ?? false
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    delegate?.tableViewDataSource(self, commit: editingStyle, forRowAt: indexPath)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    onDidScroll?(scrollView)
  }
}
