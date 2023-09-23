//
//  FacultyDetailsHeaderViewModel.swift
//  TSUAbiturient
//

import Foundation

class FacultyDetailsHeaderViewModel {
  // MARK: - Properties
  
  var logoImageURL: URL? {
    faculty.iconURL
  }
  
  var title: String {
    faculty.name
  }
  
  private let faculty: Faculty
  
  // MARK: - Init
  
  init(faculty: Faculty) {
    self.faculty = faculty
  }
}
