//
//  ProgramListItemViewModel.swift
//  TSUAbiturient
//

import Foundation
final class ProgramListItemViewModel {
  
  private let program: EducationProgram
  
  var id: String {
    "\(program.priority)_\(program.educationBase.rawValue)"
  }
  var title: String {
    program.educationProgram.speciality.name
  }
  
  var faculty: String {
    program.educationProgram.faculty.name
  }
  
  var priority: String {
    "\(program.priority)"
  }
  
  init(educationProgram: EducationProgram) {
    self.program = educationProgram
  }
}

// MARK: - TableCellViewModel

extension ProgramListItemViewModel: TableCellViewModel {
  var tableReuseIdentifier: String {
    ProgramListItemCell.reuseIdentifier
  }
}

// MARK: - Hashable

extension ProgramListItemViewModel: Hashable {
  static func == (lhs: ProgramListItemViewModel, rhs: ProgramListItemViewModel) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
