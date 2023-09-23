//
//  BannerShowing.swift
//  TSUAbiturient
//

import UIKit
import NotificationBannerSwift

class BannerColors: BannerColorsProtocol {
  func color(for style: BannerStyle) -> UIColor {
    switch style {
    case .danger:
      return .red
    case .info:
      return .blue
    case .customView:
      return .black
    case .success:
      return .green
    case .warning:
      return .yellow
    }
  }
}

protocol BannerShowing {
  func showBanner(title: String?, subtitle: String?, style: BannerStyle)
}

extension BannerShowing {
  func showBanner(title: String?, subtitle: String?, style: BannerStyle) {
    let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                            titleFont: title == nil ? nil : .Bold.body,
                                            titleColor: title == nil ? nil : .Light.Global.white,
                                            subtitleFont: subtitle == nil ? nil : .Regular.body,
                                            subtitleColor: subtitle == nil ? nil : .Light.Global.white,
                                            style: style, colors: BannerColors())
    banner.bannerQueue.dismissAllForced()
    banner.show(edgeInsets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
                cornerRadius: 8, shadowColor: .Light.Global.black, shadowOpacity: 0.15, shadowBlurRadius: 24)
  }
}
