//
//  MapMarkerViewModel.swift
//  TSUAbiturient
//

import UIKit

enum MapMarkerType {
  case universityBuilding

  var icon: UIImage? {
    switch self {
    case .universityBuilding:
      return Assets.Images.mapMarkerUniversity.image
    }
  }
}

enum MapMarkerSize {
  case small, big

  var frame: CGRect {
    switch self {
    case .small:
      return CGRect(x: 0, y: 0, width: 24, height: 24)
    case .big:
      return CGRect(x: 0, y: 0, width: 32, height: 32)
    }
  }
}

final class MapMarkerViewModel {
  let icon: UIImage?
  let frame: CGRect
  let title: String?
  let subtitle: String?

  var hasCallout: Bool {
    title != nil || subtitle != nil
  }

  init(type: MapMarkerType, size: MapMarkerSize, title: String? = nil, subtitle: String? = nil) {
    self.icon = type.icon
    self.frame = size.frame
    self.title = title
    self.subtitle = subtitle
  }
}
