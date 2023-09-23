//
//  CalculatorHeaderViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol CalculatorHeaderViewModelDelegate: AnyObject {
  func transferTableData(educationsType: [EducationFormListSections], headerHeight: CGFloat)
}

final class CalculatorHeaderViewModel: TableHeaderFooterViewModel {
  // MARK: - Properties

  let title: String

  weak var delegate: CalculatorHeaderViewModelDelegate?
  
  var onDidTapOnTitle: (() -> Void)?
  
  var onDidUpdateHeaderViewClosure: (() -> Void)?
  
  var onDidUpdateDirectionsSelectionViewClosure: (() -> Void)?
  
  var updateSubjectsListData: ((String) -> Void)?

  var tableReuseIdentifier: String {
    CalculatorHeader.reuseIdentifier
  }

  var curTableData: Directions?

  private var educationsTypeList: [EducationFormListSections] = []

  // MARK: - Init

  init(title: String) {
    self.title = title
  }

  // MARK: - Methods

  func filterDirectionsList(educationType: EducationFormListSections, tagType: TagSelectionState, headerHeight: CGFloat) {
    if tagType == .unselected {
      educationsTypeList.append(educationType)
      delegate?.transferTableData(educationsType: educationsTypeList, headerHeight: headerHeight)
    } else {
      educationsTypeList = educationsTypeList.filter { $0 != educationType }
      delegate?.transferTableData(educationsType: educationsTypeList, headerHeight: headerHeight)
    }
  }
}
