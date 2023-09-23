//
//  DirectionListDataSource.swift
//  TSUAbiturient
//

import UIKit

final class DirectionListDataSource: UITableViewDiffableDataSource<DirectionsListSections, DirectionCellViewModel> {
  // MARK: - Properties

  private var headerViewModel = CalculatorHeaderViewModel(title: Localizable.Calculator.tableTitle)

  private let tableView: UITableView

  private let viewModel: CalculatorViewModel

  private let headerView: CalculatorHeader

  // MARK: - Init

  init(tableView: UITableView, viewModel: CalculatorViewModel, headerView: CalculatorHeader) {
    self.tableView = tableView
    self.viewModel = viewModel
    self.headerView = headerView

    super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: DirectionCell.reuseIdentifier,
                                                     for: indexPath) as? DirectionCell
      else {
        return UITableViewCell()
      }
      cell.configure(with: itemIdentifier)
      return cell
    }

    headerViewModel.delegate = self.viewModel

    headerViewModel.onDidTapOnTitle = { [weak self] in
      self?.viewModel.loadDirectionsSelectionView()
    }

    viewModel.updateSubjectsListClosure = { [weak self] data in
      var subjectsList = ""
      for subject in data where !subject.subjectScore.isEmpty {
        subjectsList += subject.subjectName + ", "
      }
      subjectsList = String(subjectsList.dropLast(2))
      self?.headerViewModel.updateSubjectsListData?(subjectsList)

      self?.headerViewModel.onDidUpdateDirectionsSelectionViewClosure = {
        self?.viewModel.transferSubjectsData(data: data)
      }
    }

    headerViewModel.onDidUpdateHeaderViewClosure = { [weak self] in
      self?.tableView.beginUpdates()
      self?.tableView.endUpdates()
    }

    headerView.configure(with: headerViewModel)

    tableView.delegate = self
  }

  // MARK: - Update methods

  func reload(animated: Bool = false) {
    apply(snapshot(), animatingDifferences: true)
    var snapshot = snapshot()
    snapshot.deleteAllItems()

    snapshot.appendSections([.chooseSubjects])

    snapshot.appendItems(viewModel.sectionViewModels, toSection: .chooseSubjects)

    apply(snapshot, animatingDifferences: animated)
  }
}

// MARK: - UITableViewDelegate

extension DirectionListDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return headerView
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.tableItems[.chooseSubjects]?.element(at: indexPath.row)?.selectCurrentCell()
  }

  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let headerView = view as? CalculatorHeader {
      headerView.contentView.backgroundColor = .Light.Surface.primary
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    UITableView.automaticDimension
  }
}
