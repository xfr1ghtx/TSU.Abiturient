//
//  DirectionsSelectionHeaderViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol DirectionsSelectionHeaderViewModelDelegate: AnyObject {
  func clearSubjectsData()
}

final class DirectionsSelectionHeaderViewModel: TableHeaderFooterViewModel {
  weak var delegate: DirectionsSelectionHeaderViewModelDelegate?
  
  var isResetButtonAccessed: Bool
  
  var changeAccessInResetButton: ((Bool) -> Void)?
  
  var subjectsData: [DisciplineTableCellViewModel]?
  
  var tableReuseIdentifier: String {
    DirectionsSelectionHeader.reuseIdentifier
  }
  
  init() {
    self.isResetButtonAccessed = false
  }
  
  func clearSubjectsData() {
    if let subjectData = subjectsData {
      subjectData.forEach { subject in
        subject.subjectScore = ""
        subject.isSubjectSelected = false
      }
      isResetButtonAccessed = false
      delegate?.clearSubjectsData()
    }
  }
}

extension DirectionsSelectionHeaderViewModel: DisciplineTableCellViewModelDelegate {
  func transferViewModelData() {
    if let currentViewModelsData = subjectsData {
      isResetButtonAccessed = currentViewModelsData.contains(where: { !($0.subjectScore.isEmpty) }) ? true :
        false
      changeAccessInResetButton?(isResetButtonAccessed)
    }
  }
  
  func updateResetButtonState(data: DisciplineTableCellViewModel) {
    if !isResetButtonAccessed {
      isResetButtonAccessed = data.isSubjectSelected ? true : false
      changeAccessInResetButton?(isResetButtonAccessed)
    }
  }
}
