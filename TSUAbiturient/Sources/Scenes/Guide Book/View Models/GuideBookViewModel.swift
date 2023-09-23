//
//  GuideBookViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol GuideBookViewModelDelegate: AnyObject {
  func guideBookViewModelDidRequestToShowFaculties()
  func guideBookViewModelDidRequestToShowCalculator()
  func guideBookViewModelDidRequestToShowMap()
}

final class GuideBookViewModel: DataLoadingViewModel {
  typealias Dependencies = HasFacultiesService
  
  // MARK: - Properties
  
  weak var delegate: GuideBookViewModelDelegate?
  
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  
  var facultyTitle: String {
    currentFaculty?.name ?? ""
  }
  
  var facultyTagline: String {
    if var slogan = currentFaculty?.slogan.map({ $0.lowercased() }) {
      slogan[0] = slogan[0].capitalizedOnlyFirstLetter
      return slogan.joined(separator: " ")
    }
    return ""
  }

  var facultyImageURL: URL? {
    currentFaculty?.previewURL
  }
  
  private let dependencies: Dependencies
  
  private var faculties: [Faculty] = []
  private var currentFaculty: Faculty?
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public methods
  
  func didSelectFacultyCard() {
    delegate?.guideBookViewModelDidRequestToShowFaculties()
  }
  
  func didSelectCalculatorCard() {
    delegate?.guideBookViewModelDidRequestToShowCalculator()
  }
  
  func didSelectMapCard() {
    delegate?.guideBookViewModelDidRequestToShowMap()
  }
  
  func changeFaculty() {
    if faculties.isEmpty {
      currentFaculty = nil
    } else {
      currentFaculty = faculties[Int.random(in: 0..<faculties.count)]
    }
  }
  
  func viewIsReady() {
    loadData()
  }
  
  // MARK: - Private methods
  
  private func loadData() {
    onDidStartRequest?()
    Task {
      do {
        let faculties = try await dependencies.facultiesService.getFaculties()
        self.faculties = faculties
        await handle(faculties: faculties)
      } catch {
        await handle(error: error)
      }
    }
  }
  
  @MainActor
  private func handle(faculties: [Faculty]) {
    changeFaculty()
    onDidFinishRequest?()
    onDidLoadData?()
  }
  
  @MainActor
  private func handle(error: Error) {
    onDidFinishRequest?()
    onDidReceiveError?(error)
  }
}

private extension String {
  var capitalizedOnlyFirstLetter: String {
          let firstLetter = self.prefix(1).capitalized
          let remainingLetters = self.dropFirst().lowercased()
          return firstLetter + remainingLetters
      }
}
