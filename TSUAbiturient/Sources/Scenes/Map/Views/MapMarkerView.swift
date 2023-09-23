//
//  MapMarkerView.swift
//  TSUAbiturient
//

import Foundation
import MapKit

final class MapMarkerView: MKAnnotationView, ReuseIdentifiable {
  // MARK: - Configure

  func configure(with viewModel: MapMarkerViewModel) {
    image = viewModel.icon
    frame = viewModel.frame
    centerOffset = CGPoint(x: 0, y: -(viewModel.frame.height / 2))
    canShowCallout = viewModel.hasCallout
    detailCalloutAccessoryView = makeCalloutView(title: viewModel.title,
                                                 subtitle: viewModel.subtitle)
  }
  
  // MARK: - Private methods
  
  private func makeCalloutView(title: String?, subtitle: String?) -> UIView {
    let stackView = UIStackView()
    stackView.axis = .vertical

    let containerView = UIView()
    containerView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.bottom.equalToSuperview().inset(4)
    }
    
    if !title.isEmptyOrNil {
      let titleLabel = Label(textStyle: .bodyBold)
      titleLabel.text = title
      titleLabel.numberOfLines = 0
      titleLabel.textAlignment = .center
      stackView.addArrangedSubview(titleLabel)
    }
    
    if !subtitle.isEmptyOrNil {
      let subtitleLabel = Label(textStyle: .body)
      subtitleLabel.text = subtitle
      subtitleLabel.numberOfLines = 0
      subtitleLabel.textAlignment = .center
      stackView.addArrangedSubview(subtitleLabel)
    }
    
    return containerView
  }
}
