//
//  FacultyCardViewModel.swift
//  TSUAbiturient
//

import UIKit

class FacultyCardViewModel {
  var id: Int {
    faculty.id
  }
  
  var mainImageURL: URL? {
    faculty.previewURL
  }
  
  var title: String {
    faculty.name
  }
  
  var logoURL: URL? {
    faculty.iconURL
  }
  
  var slogan: [String] {
    faculty.slogan
  }
  
  var sloganPosition: Faculty.SloganPosition {
    faculty.sloganPosition
  }
  
  var sloganColor: UIColor? {
    faculty.sloganColor
  }
  
  private let faculty: Faculty
  
  init(faculty: Faculty) {
    self.faculty = faculty
  }
}

// MARK: - TableCellViewModel

extension FacultyCardViewModel: TableCellViewModel {
  var tableReuseIdentifier: String {
    FacultyCardCell.reuseIdentifier
  }
}

// MARK: - Hashable

extension FacultyCardViewModel: Hashable {
  static func == (lhs: FacultyCardViewModel, rhs: FacultyCardViewModel) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
