//
//  EventsDataSource.swift
//  TSUAbiturient
//

import UIKit

enum EventsListSections: Int, Hashable {
  case events = 0
}

final class EventsDataSource: UITableViewDiffableDataSource<EventsListSections, EventCardViewModel> {
  // MARK: - Properties
  
  private let tableView: UITableView
  private let viewModel: EventsViewModel
  
  // MARK: - Init
  
  init(tableView: UITableView, viewModel: EventsViewModel) {
    self.tableView = tableView
    self.viewModel = viewModel
    
    super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCardCell.reuseIdentifier,
                                                     for: indexPath) as? EventCardCell else { return UITableViewCell() }
      cell.configure(with: itemIdentifier)
      return cell
    }
    
    tableView.delegate = self
  }
  
  func reload(animated: Bool = true) {
    var snapshot = snapshot()
    snapshot.deleteAllItems()
    
    let sections: [EventsListSections] = viewModel.tableItems.compactMap { $0.key }
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

extension EventsDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = EventsListSections(rawValue: indexPath.section) else { return }
    viewModel.tableItems[section]?.element(at: indexPath.row)?.select()
  }
}
