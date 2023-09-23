//
//  FacultiesViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol FacultiesViewModelDelegate: AnyObject {
  func facultiesViewModel(_ viewModel: FacultiesViewModel, didSelect faculty: Faculty)
}

class FacultiesViewModel: DataLoadingViewModel {
  typealias Dependencies = HasFacultiesService
  
  weak var delegate: FacultiesViewModelDelegate?
  
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  
  private(set) var cellViewModels: [FacultyCardViewModel] = []
  
  private let dependencies: Dependencies
  
  private var faculties: [Faculty] = []
  private var filteredFaculties: [Faculty] = []
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  func loadData() {
    onDidStartRequest?()
    Task {
      do {
        let faculties = try await dependencies.facultiesService.getFaculties()
        self.faculties = faculties
        self.filteredFaculties = faculties
        await handle(faculties: faculties)
      } catch {
        await handle(error: error)
      }
    }
  }
  
  func updateSearch(with text: String?) {
    if let text = text, !text.isEmpty {
      filteredFaculties = faculties.filter { $0.name.lowercased().contains(text.lowercased()) }
    } else {
      filteredFaculties = faculties
    }

    cellViewModels = makeViewModels(faculties: filteredFaculties)
    onDidLoadData?()
  }
  
  func select(index: Int) {
    guard let faculty = filteredFaculties.element(at: index) else { return }
    delegate?.facultiesViewModel(self, didSelect: faculty)
  }
  
  @MainActor
  private func handle(faculties: [Faculty]) {
    cellViewModels = makeViewModels(faculties: faculties)
    onDidFinishRequest?()
    onDidLoadData?()
  }
  
  @MainActor
  private func handle(error: Error) {
    onDidFinishRequest?()
    onDidReceiveError?(error)
  }
  
  private func makeViewModels(faculties: [Faculty]) -> [FacultyCardViewModel] {
    return faculties.map { FacultyCardViewModel(faculty: $0) }
  }
}
