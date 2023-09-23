//
//  FacultyDetailsViewModel.swift
//  TSUAbiturient
//

import Foundation
import MapKit

enum FacultyDetailsViewModelError: LocalizedError {
  case failedToLoadFaculty
}

class FacultyDetailsViewModel: DataLoadingViewModel {
  typealias Dependencies = HasFacultiesService
  
  // MARK: - Properties
  
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  var onNeedsToOpenURL: ((_ url: URL) -> Void)?

  private(set) var headerViewModel: FacultyDetailsHeaderViewModel?

  var pictureURLs: [URL?] {
    faculty?.pictureURLs ?? []
  }

  var description: String? {
    faculty?.description
  }

  var buildings: [Building] {
    faculty?.buildings ?? []
  }
  
  var contacts: [FacultyContact] {
    faculty?.contacts ?? []
  }
  
  var abiturientLinks: [FacultyLink] {
    faculty?.links.filter { $0.type == .abiturient } ?? []
  }
  
  var otherLinks: [FacultyLink] {
    faculty?.links.filter { $0.type == .other } ?? []
  }

  private var faculty: Faculty?
  
  private let facultyID: Int
  private let dependencies: Dependencies
  
  // MARK: - Init
  
  init(facultyID: Int, dependencies: Dependencies) {
    self.facultyID = facultyID
    self.dependencies = dependencies
  }
  
  func loadData() {
    onDidStartRequest?()
    Task {
      do {
        let faculty = try await dependencies.facultiesService.getFaculty(id: facultyID)
        guard let faculty = faculty else {
          await handle(error: FacultyDetailsViewModelError.failedToLoadFaculty)
          return
        }
        await handle(faculty: faculty)
        onDidFinishRequest?()
      } catch {
        onDidFinishRequest?()
        await handle(error: error)
      }
    }
  }
  
  func openMap(building: Building) {
    let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: building.latitude,
                                                                                          longitude: building.longitude)))
    destination.name = building.name
            
    MKMapItem.openMaps(with: [destination],
                       launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
  }
  
  func openContact(_ contact: FacultyContact) {
    let link: String
    switch contact.type {
    case .email:
      link = "mailto:\(contact.contact)"
    case .phone:
      link = "tel:\(contact.contact.filter("0123456789".contains))"
    }
    if let url = URL(string: link) {
      onNeedsToOpenURL?(url)
    }
  }
  
  // MARK: - Private methods
  
  @MainActor
  private func handle(faculty: Faculty) {
    self.faculty = faculty
    headerViewModel = FacultyDetailsHeaderViewModel(faculty: faculty)
    onDidLoadData?()
  }
  
  @MainActor
  private func handle(error: Error) {
    onDidReceiveError?(error)
  }
}
