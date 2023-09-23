//
//  MapViewModel.swift
//  TSUAbiturient
//

import Foundation
import MapKit

final class MapViewModel: DataLoadingViewModel {
  typealias Dependencies = HasBuildingsService
  
  // MARK: - Properties
  
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?

  private(set) var annotations: [MKPointAnnotation] = []
  
  private var annotationsBuildings: [MKPointAnnotation: Building] = [:]
  
  private let dependencies: Dependencies
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public methods

  func loadData() {
    onDidStartRequest?()
    
    Task {
      do {
        let buildings = try await dependencies.buildingsService.getBuildings()
        await handle(buildings: buildings)
      } catch {
        await handle(error: error)
      }
    }
  }
  
  func markerViewModel(annotation: MKPointAnnotation) -> MapMarkerViewModel {
    return MapMarkerViewModel(type: .universityBuilding, size: .big,
                              title: annotationsBuildings[annotation]?.name,
                              subtitle: annotationsBuildings[annotation]?.address)
  }
  
  // MARK: - Private methods
  
  @MainActor
  private func handle(buildings: [Building]) {
    annotationsBuildings.removeAll()
    annotations = buildings.compactMap { building in
      let annotation = MKPointAnnotation()
      annotation.coordinate = building.coordinate
      annotationsBuildings[annotation] = building
      return annotation
    }
    onDidFinishRequest?()
    onDidLoadData?()
  }
  
  @MainActor
  private func handle(error: Error) {
    onDidFinishRequest?()
    onDidReceiveError?(error)
  }
}
