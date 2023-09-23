//
//  GoToSettingsAlertShowing.swift
//  TSUAbiturient
//

import UIKit

protocol GoToSettingsAlertShowing {
  func showGoToSettingsAlert(title: String?, description: String?, cancelButtonTitle: String?)
}

extension GoToSettingsAlertShowing where Self: UIViewController {
  func showGoToSettingsAlert(title: String?, description: String?, cancelButtonTitle: String?) {
    let alertController = UIAlertController(title: title, message: description,
                                            preferredStyle: .alert)
    let settingsAction = UIAlertAction(title: Localizable.Common.settingsOpen,
                                       style: .default) { [weak self] _ in
      self?.openAppSettings()
    }
    let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .default, handler: nil)

    alertController.addAction(settingsAction)
    alertController.addAction(cancelAction)

    alertController.preferredAction = settingsAction

    present(alertController, animated: true)
  }

  private func openAppSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
      UIApplication.shared.open(url)
    }
  }
}
