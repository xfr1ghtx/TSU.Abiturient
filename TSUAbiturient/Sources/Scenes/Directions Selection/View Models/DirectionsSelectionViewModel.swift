//
//  DirectionsSelectionViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol DirectionsSelectionViewModelDelegate: AnyObject {
  func transferViewModelData(_ data: [DisciplineTableCellViewModel])
  func getViewModelsData() -> [DisciplineTableCellViewModel]
}

final class DirectionsSelectionViewModel: DataLoadingViewModel {
  typealias Dependencies = DisciplinesService
  
  // MARK: - Properties
  
  weak var delegate: DirectionsSelectionViewModelDelegate?
  
  var onDidStartRequest: (() -> Void)?
  
  var onDidFinishRequest: (() -> Void)?
  
  var onDidLoadData: (() -> Void)?
  
  var onDidReceiveError: ((Error) -> Void)?
  
  var onDidUpdateSubjectsClosure: (([DisciplineTableCellViewModel]) -> Void)?
  
  private let dependencies: Dependencies
  
  var tableItems: [DisciplinesListSections: [DisciplineTableCellViewModel]] = [:]
  
  var viewModelItems: [DisciplineTableCellViewModel] = []
  
  var updatedViewModelItems: [DisciplineTableCellViewModel]?
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  func getDisciplines() {
    onDidStartRequest?()
    Task {
      do {
        let disciplines = try await dependencies.disciplinesService.getDisciplines()
        await MainActor.run {
          saveData(disciplines)
        }
      } catch {
        await MainActor.run {
          onDidReceiveError?(error)
        }
      }
    }
  }
  
  func saveData(_ data: Disciplines) {
    onDidFinishRequest?()
    
    let disciplinesData = data.subjects.compactMap { $0 }
    
    let viewModels = disciplinesData.map { DisciplineTableCellViewModel(subjectData: $0) }
    
    updatedViewModelItems = delegate?.getViewModelsData()
    
    if let currentViewModelItems = updatedViewModelItems,
       !currentViewModelItems.isEmpty {
      viewModelItems = currentViewModelItems
      tableItems[.chooseDisciplines] = currentViewModelItems
    } else {
      viewModelItems = viewModels
      
      if tableItems[.chooseDisciplines] != nil {
        tableItems[.chooseDisciplines]?.append(contentsOf: viewModels)
      } else {
        tableItems[.chooseDisciplines] = viewModels
      }
    }
    
    onDidLoadData?()
  }
}

extension DirectionsSelectionViewModel: DisciplinesListDataSourceDelegate {
  func transferData(tableDataCell: DisciplineTableCellViewModel) {
    viewModelItems.forEach { item in
      if item.subjectData.id == tableDataCell.subjectData.id {
        item.subjectScore = tableDataCell.subjectScore
        item.isSubjectSelected = tableDataCell.isSubjectSelected
      }
    }
  }
}
