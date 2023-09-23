//
//  EmptyStateViewModel.swift
//  TSUAbiturient
//

import UIKit

struct EmptyStateViewModel {
  let image: UIImage?
  let imageSize: CGSize?
  let title: String?
  let subtitle: String?
  let additionalText: String?
  let additionalTextFont: UIFont?

  var shouldHideImage: Bool {
    image == nil
  }

  var shouldHideTitle: Bool {
    title.isEmptyOrNil
  }

  var shouldHideSubtitle: Bool {
    subtitle.isEmptyOrNil
  }

  var shouldHideAdditionalText: Bool {
    additionalText.isEmptyOrNil
  }

  init(image: UIImage?, imageSize: CGSize?, title: String?, subtitle: String?,
       additionalText: String? = nil, additionalTextFont: UIFont? = nil) {
    self.image = image
    self.imageSize = imageSize
    self.title = title
    self.subtitle = subtitle
    self.additionalText = additionalText
    self.additionalTextFont = additionalTextFont
  }
}
