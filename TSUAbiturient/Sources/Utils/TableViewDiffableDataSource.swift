//
//  TableViewDiffableDataSource.swift
//  TSUAbiturient
//

import UIKit

enum DefaultTableSection {
  case main
}

protocol TableViewDiffableDataSourceDelegate: AnyObject {
  func tableViewDiffableDataSource(didSelectItemAt indexPath: IndexPath)
}

class TableViewDiffableDataSource<Cell: UITableViewCell & TableCell, Section: Hashable, Model: Hashable & TableCellViewModel>
: NSObject, UITableViewDelegate {
  weak var delegate: TableViewDiffableDataSourceDelegate?
  
  private var dataSource: UITableViewDiffableDataSource<Section, Model>?
  
  func setup(tableView: UITableView) {
    tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    tableView.delegate = self
    dataSource = UITableViewDiffableDataSource<Section, Model>(tableView: tableView) { tableView, indexPath, viewModel in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
        return UITableViewCell()
      }
      cell.configure(with: viewModel)
      return cell
    }
  }
  
  func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Model> {
    return NSDiffableDataSourceSnapshot<Section, Model>()
  }
  
  func apply(_ snapshot: NSDiffableDataSourceSnapshot<Section, Model>, animated: Bool = false) {
    dataSource?.apply(snapshot, animatingDifferences: animated)
  }
  
  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.tableViewDiffableDataSource(didSelectItemAt: indexPath)
  }
}
