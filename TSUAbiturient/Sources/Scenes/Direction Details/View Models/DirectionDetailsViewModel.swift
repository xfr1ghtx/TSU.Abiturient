//
//  DirectionDetailsViewModel.swift
//  TSUAbiturient
//

import Foundation

final class DirectionDetailsViewModel {
  // MARK: - Properties
  
  var directionNameTitle: String {
    return directionDetails.name
  }
  
  var directionDescriptionTitle: String {
    return directionDetails.directionGUID + " • " + directionDetails.direction +
      " • " + directionDetails.faculty
  }
  
  var shortDescriptionDirectionLabel: String {
    return directionDetails.profile
  }
  
  var lavelTagsName: String {
    return directionDetails.level
  }
  
  var educationFormTagsName: String {
    return directionDetails.educationForm
  }
  
  var budgetCountValue: String {
    return String(directionDetails.budgetCount)
  }
  
  var paidCountValue: String {
    return String(directionDetails.paidCount)
  }
  
  var descriptionOfDirectionLabel: String {
    return directionDetails.description
  }
  
  var entranceRequiredListSubjectsLabel: String {
    return directionDetails.reqDisciplines
  }
  
  var entranceOptionalListSubjectsLabel: String {
    return directionDetails.optDisciplines
  }
  
  var passingScoreCountLabel: String {
    return String(directionDetails.score)
  }
  
  var costOfStudyCountLabel: String {
    return Localizable.Calculator.currencyRuble((NumberFormatter.formatCurrency(Double(directionDetails.cost)
                                                                                ?? 0.0, withDecimal: false)))
  }
  
  var periodTagsName: String {
    return NumberFormatter.formatYear(directionDetails.period)
  }

  private let directionDetails: EducationDirection
  
  // MARK: - Init
  
  init(directionDetails: EducationDirection) {
    self.directionDetails = directionDetails
  }
}
