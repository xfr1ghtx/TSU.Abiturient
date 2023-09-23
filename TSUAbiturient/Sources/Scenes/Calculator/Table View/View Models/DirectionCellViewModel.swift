//
//  DirectionCellViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol DirectionCellViewModelDelegate: AnyObject {
  func directionCardViewModel(_ viewModel: DirectionCellViewModel, didRequestToShow directionDetails: EducationDirection)
}

final class DirectionCellViewModel {
  // MARK: - Properties
  
  weak var delegate: (DirectionCellViewModelDelegate)?

  var directionTitle: String {
    return direction.direction
  }

  var facultySubTitle: String {
    return direction.faculty
  }

  var description: String {
    return direction.description
  }

  var educationForm: String {
    return direction.educationForm
  }

  var period: String {
    return direction.period
  }

  private let direction: EducationDirection

  // MARK: - Init

  init(direction: EducationDirection, delegate: DirectionCellViewModelDelegate) {
    self.direction = direction
    self.delegate = delegate
  }

  func selectCurrentCell() {
    delegate?.directionCardViewModel(self, didRequestToShow: direction)
  }
}

// MARK: - DirectionViewModel

extension DirectionCellViewModel: TableCellViewModel {
  var tableReuseIdentifier: String {
    DirectionCell.reuseIdentifier
  }
}

extension DirectionCellViewModel: Equatable {
  static func == (lhs: DirectionCellViewModel, rhs: DirectionCellViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

extension DirectionCellViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(direction)
  }
}
