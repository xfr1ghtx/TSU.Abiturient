//
//  Building.swift
//  TSUAbiturient
//

import UIKit
import CoreLocation

struct Building: Codable {
  enum BuildingType: String, Codable {
    case academic = "ACADEMIC", dormitory = "DORMITORY", other = "OTHER"
  }
  
  let id: Int
  let address: String
  let latitude: Double
  let longitude: Double
  let name: String
  let type: BuildingType
  
  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  var typeImage: UIImage {
    switch type {
    case .academic, .other:
      return Assets.Images.academicHat.image
    case .dormitory:
      return Assets.Images.dormitory.image
    }
  }
  
  var typeTitle: String {
    switch type {
    case .academic:
      return Localizable.Faculties.locationAcademicTitle
    case .dormitory:
      return Localizable.Faculties.locationDormitoryTitle
    case .other:
      return Localizable.Faculties.locationOtherTitle
    }
  }
}
