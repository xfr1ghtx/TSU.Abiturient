//
//  DisciplinesListDataSource.swift
//  TSUAbiturient
//

import UIKit

protocol DisciplinesListDataSourceDelegate: AnyObject {
  func transferData(tableDataCell: DisciplineTableCellViewModel)
}

final class DisciplinesListDataSource: UITableViewDiffableDataSource<DisciplinesListSections, DisciplineTableCellViewModel> {
  weak var delegate: DisciplinesListDataSourceDelegate?
  
  private let tableView: UITableView
  
  private let viewModel: DirectionsSelectionViewModel
  
  private var headerView: DirectionsSelectionHeader
  
  private var clearScoreDataSubjectsClosure: ((DisciplineTableCellViewModel) -> Void)?
  
  private var headerViewModel = DirectionsSelectionHeaderViewModel()
  
  init(tableView: UITableView, viewModel: DirectionsSelectionViewModel, headerView: DirectionsSelectionHeader) {
    self.tableView = tableView
    self.viewModel = viewModel
    self.headerView = headerView
    
    super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: DisciplineCell.reuseIdentifier,
                                                     for: indexPath) as? DisciplineCell
      else {
        return UITableViewCell()
      }
      cell.configure(with: itemIdentifier)
      return cell
    }
    tableView.delegate = self
  }
  
  func saveSnapshot(animated: Bool = false) {
    var snapshot = snapshot()
    snapshot.deleteAllItems()

    let sections: [DisciplinesListSections] = viewModel.tableItems.compactMap { $0.key }
    snapshot.appendSections(sections)
    defaultRowAnimation = .none

    sections.forEach { section in
      if let items = viewModel.tableItems[section] {
        items.forEach { item in
          item.delegate = headerViewModel
        }
        snapshot.appendItems(items, toSection: section)
      }
    }
    
    apply(snapshot, animatingDifferences: animated)
  }
}

extension DisciplinesListDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    headerViewModel.subjectsData = viewModel.viewModelItems
    headerViewModel.delegate = self
    headerView.configure(with: headerViewModel)
    return headerView
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return nil
  }
}

extension DisciplinesListDataSource: DirectionsSelectionHeaderViewModelDelegate {
  func clearSubjectsData() {
    viewModel.tableItems[.chooseDisciplines]?.forEach { subject in
      subject.clearSubjectDataClosure?()
    }
  }
}
