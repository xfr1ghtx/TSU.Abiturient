//
//  SimpleSectionHeaderViewModel.swift
//  TSUAbiturient
//

import Foundation

final class SimpleSectionHeaderViewModel: TableHeaderFooterViewModel {
  // MARK: - Properties
  
  var tableReuseIdentifier: String {
    SimpleSectionHeader.reuseIdentifier
  }
  
  let title: String
  
  // MARK: - Init
  
  init(title: String) {
    self.title = title
  }
}
