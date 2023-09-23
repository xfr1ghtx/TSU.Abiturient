//
//  MapViewController.swift
//  TSUAbiturient
//

import Foundation
import UIKit
import MapKit

final class MapViewController: BaseViewController, DataLoadingView, ActivityIndicatorViewDisplaying,
                         ErrorHandling, EmptyStateErrorViewDisplaying {
  // MARK: - Properties

  let activityIndicatorView = UIActivityIndicatorView()
  let emptyStateErrorView = EmptyStateErrorView()

  private let mapView = MKMapView()

  private let viewModel: MapViewModel

  // MARK: - Init

  init(viewModel: MapViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind(to: viewModel)
    viewModel.loadData()
  }

  // MARK: - Pubic methods

  func handleRequestStarted() {
    mapView.isHidden = true
  }

  func handleRequestFinished() {
    mapView.isHidden = false
  }
  
  func handleRefreshButtonTapped() {
    viewModel.loadData()
  }

  func reloadData() {
    mapView.removeAnnotations(mapView.annotations)
    mapView.showAnnotations(viewModel.annotations, animated: false)
  }

  // MARK: - Setup

  private func setup() {
    setupMapView()
    setupActivityIndicatorView()
    setupEmptyStateErrorView()
  }

  private func setupMapView() {
    view.addSubview(mapView)
    mapView.delegate = self
    mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? MKPointAnnotation else { return nil }
    let annotationViewModel = viewModel.markerViewModel(annotation: annotation)
    if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MapMarkerView.reuseIdentifier) {
      (annotationView as? MapMarkerView)?.configure(with: annotationViewModel)
      annotationView.annotation = annotation
      return annotationView
    } else {
      let annotationView = MapMarkerView(annotation: annotation, reuseIdentifier: MapMarkerView.reuseIdentifier)
      annotationView.configure(with: annotationViewModel)
      return annotationView
    }
  }
}
