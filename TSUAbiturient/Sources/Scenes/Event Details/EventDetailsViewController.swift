//
//  EventDetailsViewController.swift
//  TSUAbiturient
//

import UIKit
import SnapKit
import WebKit

private extension Constants {
  static let headerHeight: CGFloat = 283
}

final class EventDetailsViewController: BaseViewController, NavigationBarHiding {
  // MARK: - Properties
  
  private let backButton = UIButton()
  private let headerImageView = UIImageView()
  private let darkGradientView = UIView()
  private let lightGradientView = UIView()
  private let scrollView = UIScrollView()
  private let scrollContentView = UIView()
  private let categoryTag = UIView()
  private let contentContainer = UIStackView()
  private let nameLabel = Label(textStyle: .header3)
  private let dateLabel = Label(textStyle: .body)
  private let announceLabel = Label(textStyle: .body)
  private let addressTitleLabel = Label(textStyle: .bodyBold)
  private let addressLabel = Label(textStyle: .body)
  private let descriptionTitleLabel = Label(textStyle: .bodyBold)
  private let descriptionLabel = Label(textStyle: .body)
  
  private lazy var darkGradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.Gradient.blackFullTransparent.cgColor, UIColor.Gradient.blackTransparent.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    
    return gradientLayer
  }()
  
  private lazy var lightGradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.Gradient.white.cgColor, UIColor.Gradient.whiteTransparent.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    
    return gradientLayer
  }()
  
  private var oldContentOffset: CGFloat = -259
  private var headerHeightConstraint: Constraint?

  private let viewModel: EventDetailsViewModel
  
  // MARK: - Inits
  
  init(viewModel: EventDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("EventDetailsViewController init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    darkGradientLayer.frame = darkGradientView.bounds
    lightGradientLayer.frame = lightGradientView.bounds
  }
  
  // MARK: - Action
  
  @objc
  private func tapOnBackButton() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc
  private func tapOnAddressURL() {
    guard let url = viewModel.addressURL else { return }
    UIApplication.shared.open(url)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupHeaderImageView()
    setupDarkGradientView()
    setupScrollView()
    setupLightGradientView()
    setupCategoryTag()
    setupContentContainer()
    setupNameLabel()
    setupDateLabel()
    setupBackButton()
    setupAnnounceLabel()
    if viewModel.address != nil {
      setupAddressTitleLabel()
      setupAddressLabel()
    }
    setupDescriptionTitleLabel()
    setupDescriptionLabel()
  }
  
  private func setupHeaderImageView() {
    view.addSubview(headerImageView)
    headerImageView.setImage(with: viewModel.imageURL, placeholder: nil, options: [.backgroundDecode])
    headerImageView.contentMode = .scaleAspectFill
    headerImageView.layer.masksToBounds = true
    headerImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
      headerHeightConstraint = make.height.equalTo(Constants.headerHeight).constraint
    }
  }
  
  private func setupDarkGradientView() {
    view.addSubview(darkGradientView)
    darkGradientView.layer.insertSublayer(darkGradientLayer, at: 0)
    darkGradientView.snp.makeConstraints { make in
      make.bottom.equalTo(headerImageView.snp.bottom)
      make.height.equalTo(Constants.headerHeight)
      make.horizontalEdges.equalToSuperview()
    }
  }
  
  private func setupScrollView() {
    view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.contentInset.top = Constants.headerHeight - 24
    scrollView.backgroundColor = .clear
    scrollView.showsVerticalScrollIndicator = false
    scrollView.delegate = self
    scrollView.addSubview(scrollContentView)
    
    scrollContentView.layer.cornerRadius = 24
    scrollContentView.layer.cornerCurve = .continuous
    scrollContentView.backgroundColor = .Light.Surface.primary
    
    scrollContentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
  }
  
  private func setupLightGradientView() {
    view.addSubview(lightGradientView)
    lightGradientView.layer.insertSublayer(lightGradientLayer, at: 0)
    lightGradientView.layer.opacity = 0
    lightGradientView.snp.makeConstraints { make in
      make.height.equalTo(60)
      make.horizontalEdges.equalToSuperview()
      make.top.equalTo(view.safeAreaInsets)
    }
  }
  
  private func setupCategoryTag() {
    let label = Label(textStyle: .footnote)
    label.textColor = .Light.Text.white
    categoryTag.addSubview(label)
    label.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(8)
      make.verticalEdges.equalToSuperview().inset(4)
    }
    label.text = viewModel.categoryName
    
    darkGradientView.addSubview(categoryTag)
    categoryTag.backgroundColor = .black.withAlphaComponent(0.4)
    categoryTag.layer.cornerRadius = 12
    categoryTag.layer.cornerCurve = .continuous
    
    categoryTag.snp.makeConstraints { make in
      make.bottom.equalTo(headerImageView.snp.bottom).inset(40)
      make.leading.equalToSuperview().inset(16)
    }
  }
  
  private func setupContentContainer() {
    scrollContentView.addSubview(contentContainer)
    contentContainer.axis = .vertical
    contentContainer.spacing = 8
    contentContainer.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(24)
    }
  }
  
  private func setupNameLabel() {
    contentContainer.addArrangedSubview(nameLabel)
    nameLabel.text = viewModel.name
    nameLabel.numberOfLines = 0
    nameLabel.textColor = .Light.Text.primary
  }
  
  private func setupDateLabel() {
    contentContainer.addArrangedSubview(dateLabel)
    dateLabel.text = viewModel.date
    dateLabel.textColor = .Light.Text.accent
    contentContainer.setCustomSpacing(16, after: dateLabel)
  }
  
  private func setupAnnounceLabel() {
    contentContainer.addArrangedSubview(announceLabel)
    announceLabel.text = viewModel.announce
    announceLabel.textColor = .Light.Text.primary
    announceLabel.numberOfLines = 0
    contentContainer.setCustomSpacing(24, after: announceLabel)
  }
  
  private func setupAddressTitleLabel() {
    contentContainer.addArrangedSubview(addressTitleLabel)
    addressTitleLabel.text = Localizable.UpcommingEvents.EventDetails.AddressLabel.title
    addressTitleLabel.textColor = .Light.Text.primary
  }
  
  private func setupAddressLabel() {
    contentContainer.addArrangedSubview(addressLabel)
    addressLabel.text = viewModel.address
    addressLabel.numberOfLines = 0
    if viewModel.addressIsURL {
      addressLabel.textColor = .Light.Text.accent
      addressLabel.isUserInteractionEnabled = true
      addressLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnAddressURL)))
    } else {
      addressLabel.textColor = .Light.Text.primary
    }
    contentContainer.setCustomSpacing(24, after: addressLabel)
  }
  
  private func setupDescriptionTitleLabel() {
    contentContainer.addArrangedSubview(descriptionTitleLabel)
    descriptionTitleLabel.text = Localizable.UpcommingEvents.EventDetails.DescriptionLabel.title
    descriptionTitleLabel.textColor = .Light.Text.primary
  }
  
  private func setupDescriptionLabel() {
    contentContainer.addArrangedSubview(descriptionLabel)
    descriptionLabel.textColor = .Light.Text.primary
    descriptionLabel.numberOfLines = 0
    descriptionLabel.attributedText = NSAttributedString(html: viewModel.description)
    descriptionLabel.font = .Regular.body
  }
  
  private func setupBackButton() {
    view.addSubview(backButton)
    backButton.layer.cornerCurve = .continuous
    backButton.layer.cornerRadius = 16
    backButton.backgroundColor = .black.withAlphaComponent(0.4)
    backButton.tintColor = .Light.Icons.white
    backButton.setImage(Assets.Images.chevronLeft.image.withRenderingMode(.alwaysTemplate), for: .normal)
    backButton.addTarget(self, action: #selector(tapOnBackButton), for: .touchUpInside)
    
    backButton.snp.makeConstraints { make in
      make.size.equalTo(32)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
      make.leading.equalToSuperview().offset(16)
    }
  }
}

// MARK: - UIScrollViewDelegate

extension EventDetailsViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let diff = oldContentOffset - scrollView.contentOffset.y
    
    guard diff != 0 else { return }
    if scrollView.contentOffset.y < 24 {
      headerHeightConstraint?.update(offset: -scrollView.contentOffset.y + 24)
    } else {
      headerHeightConstraint?.update(offset: 0)
    }
    
    if scrollView.contentOffset.y <= 0 && lightGradientView.layer.opacity == 1 {
      UIView.animate(withDuration: 0.3) { [weak self] in
        self?.lightGradientView.layer.opacity = 0
      }
    } else if scrollView.contentOffset.y > 0 && lightGradientView.layer.opacity != 1 {
      UIView.animate(withDuration: 0.3) { [weak self] in
        self?.lightGradientView.layer.opacity = 1
      }
    }
    
    headerImageView.layoutIfNeeded()
    oldContentOffset = scrollView.contentOffset.y
  }
}
