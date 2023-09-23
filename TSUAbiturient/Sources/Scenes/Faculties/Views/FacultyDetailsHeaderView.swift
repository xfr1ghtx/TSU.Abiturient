//
//  FacultyDetailsHeaderView.swift
//  TSUAbiturient
//

import UIKit

class FacultyDetailsHeaderView: UIView {
  // MARK: - Properties
  
  private let titleStackView = UIStackView()
  private let logoImageView = UIImageView()
  private let titleLabel = Label(textStyle: .bodyBold)
  
  private let galleryCollectionViewFlowLayout = UICollectionViewFlowLayout()
  
  private lazy var galleryCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: galleryCollectionViewFlowLayout)
  
  // MARK: - Init
  
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Configure
  
  func configure(with viewModel: FacultyDetailsHeaderViewModel) {
    logoImageView.setImage(with: viewModel.logoImageURL, placeholder: nil, options: nil)
    titleLabel.text = viewModel.title
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupTitleStackView()
    setupLogoImageView()
    setupTitleLabel()
  }
  
  private func setupTitleStackView() {
    addSubview(titleStackView)
    titleStackView.axis = .horizontal
    titleStackView.spacing = 16
    titleStackView.alignment = .center
    titleStackView.distribution = .fill
    titleStackView.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().inset(16)
      make.trailing.equalToSuperview().inset(64)
      make.bottom.equalToSuperview()
    }
  }
  
  private func setupLogoImageView() {
    titleStackView.addArrangedSubview(logoImageView)
    logoImageView.clipsToBounds = true
    logoImageView.layer.cornerRadius = 32
    logoImageView.contentMode = .scaleAspectFill
    logoImageView.snp.makeConstraints { make in
      make.size.equalTo(64)
    }
  }
  
  private func setupTitleLabel() {
    titleStackView.addArrangedSubview(titleLabel)
    titleLabel.numberOfLines = 0
    titleLabel.textColor = UIColor.Light.Text.primary
  }
}
