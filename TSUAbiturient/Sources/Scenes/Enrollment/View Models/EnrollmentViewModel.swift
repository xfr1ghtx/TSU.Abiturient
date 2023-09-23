//
//  EnrollmentViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol EnrollmentViewModelDelegate: AnyObject {
  func enrollmentViewModelDidRequestToShowAuth()
}

final class EnrollmentViewModel: DataLoadingViewModel {
  typealias Dependencies = HasEducationProgramsService & HasDataStore
  
  // MARK: - Properties
  
  weak var delegate: EnrollmentViewModelDelegate?
  
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  
  var hasAccountInformation: Bool {
    dependencies.dataStore.userProfile != nil
  }
  
  var hasEducationPrograms: Bool {
    return !educationPrograms.isEmpty
  }
  
  var userName: String {
    "\(dependencies.dataStore.userProfile?.firstName ?? "") \(dependencies.dataStore.userProfile?.lastName ?? "")"
  }
  
  var budgetTypes: [EducationBase] {
    return Array(educationPrograms.keys).sorted() { $0.rawValue < $1.rawValue }
  }
  
  var programListItemViewModels: [ EducationBase: [ ProgramListItemViewModel ] ] {
    var viewModels: [ EducationBase : [ ProgramListItemViewModel ] ] = [ : ]
    for type in educationPrograms.keys {
      viewModels[type] = []
      for program in educationPrograms[type]! {
        viewModels[type]! += [ProgramListItemViewModel(educationProgram: program)]
      }
    }
    return viewModels
  }
  
  private var educationPrograms: [ EducationBase : [ EducationProgram ] ] = [ : ]
  private var dependencies: Dependencies
  
  // MARK: - init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    dependencies.dataStore.observer.subscribe(self)
  }
  
  deinit {
    dependencies.dataStore.observer.unsubscribe(self)
  }
  
  // MARK: - Public methods
  
  func getViewModelsForSelectedSegmentWith(position: Int) -> [ProgramListItemViewModel] {
    return programListItemViewModels[budgetTypes.element(at: position) ?? .budget] ?? []
  }
  
  func viewIsReady() {
    if hasAccountInformation {
      loadData()
    }
  }
  
  func didSelectLoginTSUAccount() {
    delegate?.enrollmentViewModelDidRequestToShowAuth()
  }
  
  func didSelectLogout() {
    dependencies.dataStore.clearAllData()
  }
  
  // MARK: - Private methods
  
  private func loadData() {
    onDidStartRequest?()
    Task {
      do {
        let requestID = dependencies.dataStore.userProfile?.requestID ?? ""
        let educationPrograms = try await dependencies.educationProgramsService.getEducationPrograms(for: requestID)
        self.educationPrograms = group(educationPrograms: educationPrograms.data)
        await handle(educationPrograms: self.educationPrograms)
      } catch {
        await handle(error: error)
      }
    }
  }
  
  @MainActor
  private func handle(educationPrograms: [ EducationBase : [ EducationProgram ] ]) {
    onDidFinishRequest?()
    onDidLoadData?()
  }
  
  @MainActor
  private func handle(error: Error) {
    onDidFinishRequest?()
    onDidReceiveError?(error)
  }
  
  private func group(educationPrograms: [ EducationProgram ]) -> [ EducationBase : [ EducationProgram ] ] {
    var result: [ EducationBase : [ EducationProgram ] ] = [:]
    for program in educationPrograms {
      let base = program.educationBase
      if result[base] == nil {
        result[base] = [program]
      } else {
        result[base]! += [program]
      }
    }
    return result
  }
}

// MARK: DataStoreSubscriber
extension EnrollmentViewModel: DataStoreSubscriber {
  func update(event: DataStoreEvent) {
    viewIsReady()
  }
}
