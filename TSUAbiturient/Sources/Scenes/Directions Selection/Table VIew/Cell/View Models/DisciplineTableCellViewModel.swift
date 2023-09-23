//
//  DisciplineTableCellViewModel.swift
//  TSUAbiturient
//

import UIKit

protocol DisciplineTableCellViewModelDelegate: AnyObject {
  func transferViewModelData()
  func updateResetButtonState(data: DisciplineTableCellViewModel)
}

final class DisciplineTableCellViewModel {
  // MARK: - Properties

  weak var delegate: DisciplineTableCellViewModelDelegate?

  var subjectName: String {
    subjectData.name
  }

  var clearSubjectDataClosure: (() -> Void)?

  var isSubjectSelected: Bool

  var subjectScore: String = ""

  let subjectData: Subjects

  // MARK: - Init

  init(subjectData: Subjects) {
    self.subjectData = subjectData
    self.isSubjectSelected = false
  }
}

// MARK: - DirectionViewModel

extension DisciplineTableCellViewModel: TableCellViewModel {
  var tableReuseIdentifier: String {
    DisciplineCell.reuseIdentifier
  }
}

extension DisciplineTableCellViewModel: Equatable {
  static func == (lhs: DisciplineTableCellViewModel, rhs: DisciplineTableCellViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

extension DisciplineTableCellViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(subjectData)
  }
}

extension DisciplineTableCellViewModel: DisciplineTableCellViewDelegate {
  func changeCheckMarkViewWithTextField(with textField: UITextField) -> Bool {
    if let text = textField.text {
      isSubjectSelected = text.filter { $0.isNumber }.isEmpty ? false : true
      return text.filter { $0.isNumber }.isEmpty ? false : true
    }
    return false
  }

  func changeScoreTextInTextField(with textField: UITextField) {
    if let text = textField.text {
      let filteredText = text.filter { $0.isNumber }
      textField.text = filteredText
      subjectScore = filteredText
      if let number = Int(text),
         number > 100 {
        textField.text = "100"
        subjectScore = "100"
      }
      delegate?.transferViewModelData()
    }
  }
}
