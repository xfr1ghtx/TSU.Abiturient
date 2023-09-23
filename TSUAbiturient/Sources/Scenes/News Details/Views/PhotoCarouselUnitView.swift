//
//  PhotoCarouselUnitView.swift
//  TSUAbiturient
//

import UIKit

final class PhotoCarouselUnitView: UICollectionViewCell {
  // MARK: - Properties
  
  private let imageView = UIImageView()
  private var url: URL?
  
  // MARK: - Inits
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Override
  
  override func prepareForReuse() {
    imageView.image = nil
  }
  
  // MARK: - Configure
  
  func configure(with url: URL?) {
    imageView.setImage(with: url, placeholder: Assets.Images.cellPlaceholder.image, options: [.backgroundDecode])
  }
  
  // MARK: - Setup
  
  private func setup() {
    layer.cornerRadius = 16
    layer.cornerCurve = .continuous
    layer.masksToBounds = true
    setupImageView()
  }
  
  private func setupImageView() {
    contentView.addSubview(imageView)
    
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 16
    imageView.layer.cornerCurve = .continuous
    
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
