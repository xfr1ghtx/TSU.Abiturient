//
//  TableSectionViewModel.swift
//  TSUAbiturient
//

import Foundation

class TableSectionViewModel {
  let headerViewModel: TableHeaderFooterViewModel?

  private(set) var cellViewModels: [TableCellViewModel] = []

  func append(_ cellViewModel: TableCellViewModel) {
    cellViewModels.append(cellViewModel)
  }

  func append(cellViewModels: [TableCellViewModel]) {
    self.cellViewModels.append(contentsOf: cellViewModels)
  }

  func remove(at index: Int) {
    cellViewModels.remove(at: index)
  }

  init(headerViewModel: TableHeaderFooterViewModel? = nil) {
    self.headerViewModel = headerViewModel
  }
}
