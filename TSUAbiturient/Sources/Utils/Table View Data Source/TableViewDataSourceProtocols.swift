//
//  TableViewDataSourceProtocols.swift
//  TSUAbiturient
//

import Foundation

protocol TableCellViewModel {
  var tableReuseIdentifier: String { get }
  func select()
}

extension TableCellViewModel {
  func select() {}
}

protocol TableHeaderFooterViewModel {
  var tableReuseIdentifier: String { get }
}

protocol TableCell {
  func configure(with viewModel: TableCellViewModel)
}

protocol TableHeaderFooterView {
  func configure(with viewModel: TableHeaderFooterViewModel)
}

protocol TableViewModel {
  var sectionViewModels: [TableSectionViewModel] { get }
}
