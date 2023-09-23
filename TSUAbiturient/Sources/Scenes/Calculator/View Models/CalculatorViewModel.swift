//
//  CalculatorViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol CalculatorViewModelDelegate: AnyObject {
  func showSelectionsScreen()
  func transferSubjectsDataInView(data: [DisciplineTableCellViewModel])
  func directionDescriptionViewModel(_ viewModel: CalculatorViewModel, didRequestToShow directionDetails: EducationDirection)
}

final class CalculatorViewModel: DataLoadingViewModel {
  typealias Dependencies = DirectionsService
  
  // MARK: - Properties
  
  weak var delegate: CalculatorViewModelDelegate?
  
  var onDidReceiveError: ((Error) -> Void)?
  
  var onDidStartRequest: (() -> Void)?
  
  var onDidFinishRequest: (() -> Void)?
  
  var onDidLoadData: (() -> Void)?
  
  var onDidReloadTable: (() -> Void)?
  
  var onDidUpdateLoaderConstraints: ((CGFloat) -> Void)?
  var onScrollDidUpdate: ((Bool) -> Void)?
  
  var updateSubjectsListClosure: (([DisciplineTableCellViewModel]) -> Void)?

  var sectionViewModels: [DirectionCellViewModel] = []

  var tableItems: [DirectionsListSections: [DirectionCellViewModel]] = [:]

  private let dependencies: Dependencies
  
  private var directionsData: Directions?
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Methods
  
  func loadDirectionData() {
    onDidUpdateLoaderConstraints?(CGFloat(0))
    onDidStartRequest?()
    Task {
      do {
        let directions = try await dependencies.directionsService.getDirections()
        await MainActor.run {
          saveDirectionData(directions)
        }
        
      } catch {
        await MainActor.run {
          onDidReceiveError?(error)
        }
      }
    }
  }
  
  func loadDirectionsWithSubjectsData(subjects: [String]) {
    onDidUpdateLoaderConstraints?(CGFloat(0))
    onDidStartRequest?()
    Task {
      do {
        let directions = try await dependencies.directionsService.getDirectionsWithSubjectsData(subjects: subjects)
        await MainActor.run {
          saveDirectionData(directions)
        }
      } catch {
        await MainActor.run {
          onDidReceiveError?(error)
        }
      }
    }
  }
  
  func loadCurrentDirectionsWithSubjectData(data: [DisciplineTableCellViewModel]) {
    updateSubjectsListClosure?(data)
    var subjectsData: [String] = []
    
    for subject in data where subject.isSubjectSelected {
      subjectsData.append("\(subject.subjectData.id):\(subject.subjectScore)")
    }
    loadDirectionsWithSubjectsData(subjects: subjectsData)
  }
  
  func loadDirectionsSelectionView() {
    delegate?.showSelectionsScreen()
  }
  
  func transferSubjectsData(data: [DisciplineTableCellViewModel]) {
    delegate?.transferSubjectsDataInView(data: data)
  }
  
  private func saveDirectionData(_ data: Directions) {
    tableItems = [:]
    directionsData = data
    onScrollDidUpdate?(false)
    
    let directionData = data.programs.compactMap { $0 }
    
    let viewModels = directionData.compactMap { DirectionCellViewModel(direction: $0, delegate: self) }
    sectionViewModels = viewModels
    
    if tableItems[.chooseSubjects] != nil {
      tableItems[.chooseSubjects]?.append(contentsOf: viewModels)
    } else {
      tableItems[.chooseSubjects] = viewModels
    }
    
    onDidLoadData?()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.onDidFinishRequest?()
    }
    onScrollDidUpdate?(true)
  }
  
  private func updateDirectionData(_ currentDirectionData: Directions, educationsType: [EducationFormListSections]) {
    let directionData = currentDirectionData.programs.compactMap { $0 }
    var currentData: [EducationDirection] = []
    
    if educationsType.isEmpty {
      guard let currentDictionsData = directionsData else { return }
      currentData = currentDictionsData.programs.compactMap { $0 }
    } else {
      for type in educationsType {
        switch type {
        case .fullTime:
          currentData += directionData.filter { $0.educationForm == "Очная" }
        case .distantForm:
          currentData += directionData.filter { $0.educationForm == "Заочная" }
        case .partTime:
          currentData += directionData.filter { $0.educationForm == "Очно-заочная" }
        }
      }
    }
    
    let viewModels = currentData.map { DirectionCellViewModel(direction: $0, delegate: self) }
    sectionViewModels = viewModels
    
    if tableItems[.chooseSubjects] != nil {
      tableItems[.chooseSubjects]?.append(contentsOf: viewModels)
    } else {
      tableItems[.chooseSubjects] = viewModels
    }
  }
}

// MARK: - CalculatorHeaderViewModelDelegate

extension CalculatorViewModel: CalculatorHeaderViewModelDelegate {
  func transferTableData(educationsType: [EducationFormListSections], headerHeight: CGFloat) {
    onScrollDidUpdate?(false)
    onDidUpdateLoaderConstraints?(headerHeight + CGFloat(30))
    onDidStartRequest?()
    guard let currentData = directionsData else { return }
    tableItems = [:]
    updateDirectionData(currentData, educationsType: educationsType)
    onDidLoadData?()
    onDidReloadTable?()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
      self?.onDidFinishRequest?()
    }
    
    onScrollDidUpdate?(true)
  }
}

extension CalculatorViewModel: DirectionCellViewModelDelegate {
  func directionCardViewModel(_ viewModel: DirectionCellViewModel, didRequestToShow directionDetails: EducationDirection) {
    delegate?.directionDescriptionViewModel(self, didRequestToShow: directionDetails)
  }
}
