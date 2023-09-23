//
//  ProfileView.swift
//  TSUAbiturient
//

import UIKit

enum ProfileViewState {
  case unauthorized
  case haveName(String)
  case authorized([RatingDirection])
  case noPriorities
}

final class ProfileView: UIView, DataLoadingView, ActivityIndicatorViewDisplaying, ErrorHandling {
  // MARK: - Properties
  
  var activityIndicatorView = UIActivityIndicatorView()
  var activityIndicatorContainerView = UIView()
  
  var onDidUpdate: (() -> Void)?
  
  private let containerStackView = UIStackView()
  private let nameLabel = Label(textStyle: .header1)
  private let profileInfoContainer = UIStackView()
  
  private var viewModel: ProfileViewModel?
  
  lazy private var authView: UIView = {
    let view = UIView()
    let label = Label(textStyle: .header3)
    let button = CommonButton()
    
    view.addSubview(label)
    view.addSubview(button)
    
    label.textColor = .Light.Text.primary
    label.text = Localizable.Profile.hasProfileQuestion
    
    button.setTitle(Localizable.Profile.tsuLoginButtonTitle, for: .normal)
    button.setLeftImage(Assets.Images.tsuLogo.image, for: .normal)
    button.addTarget(self, action: #selector(tapOnLogin), for: .touchUpInside)
    
    label.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(8)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    button.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(8)
      make.bottom.equalToSuperview().inset(8)
      make.trailing.leading.equalToSuperview().inset(16)
    }
    
    return view
  }()
  
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
  
  func configure(with viewModel: ProfileViewModel) {
    self.viewModel = viewModel
    bind(to: viewModel)
    bindToViewModel(viewModel)
    viewModel.loadData()
  }
  
  // MARK: - BindToViewModel
  
  private func bindToViewModel(_ viewModel: ProfileViewModel ) {
    viewModel.onDidUpdateProfile = {[weak self] state in
      self?.updateAppearance(with: state)
    }
  }
  
  // MARK: - Action
  
  @objc
  private func tapOnLogin() {
    viewModel?.tapOnLogin()
  }
  
  // MARK: - Public methods
  
  func handleRequestStarted() {
    activityIndicatorContainerView.isHidden = false
  }
  
  func handleRequestFinished() {
    activityIndicatorContainerView.isHidden = true
  }
  
  // MARK: - Private methods
  
  private func updateAppearance(with state: ProfileViewState) {
    profileInfoContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
    switch state {
    case .unauthorized:
      makeAuthView()
      makeName(nil)
    case .authorized(let directions):
      makeDirections(directions)
    case .haveName(let name):
      makeName(name)
    case .noPriorities:
      profileInfoContainer.isHidden = true
      updateLayout()
    }
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainerStackView()
    setupNameLabel()
    setupProfileInfoContainer()
    setupActivityIndicatorContainerView()
    setupActivityIndicatorView()
  }
  
  private func setupContainerStackView() {
    addSubview(containerStackView)
    containerStackView.spacing = 24
    containerStackView.axis = .vertical
    containerStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupNameLabel() {
    containerStackView.addArrangedSubview(nameLabel)
    nameLabel.isHidden = true
    nameLabel.textColor = .Light.Text.white
    nameLabel.text = ""
    nameLabel.numberOfLines = 0
  }
  
  private func setupProfileInfoContainer() {
    containerStackView.addArrangedSubview(profileInfoContainer)
    profileInfoContainer.axis = .vertical
    profileInfoContainer.backgroundColor = .Light.Surface.primary
    profileInfoContainer.layer.cornerRadius = 24
    profileInfoContainer.layer.cornerCurve = .continuous
    profileInfoContainer.spacing = 8
    profileInfoContainer.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    profileInfoContainer.isLayoutMarginsRelativeArrangement = true
    profileInfoContainer.addShadow(offset: CGSize(width: 0, height: 12),
                                   radius: 12,
                                   color: .Light.Global.black,
                                   opacity: 0.08)
    profileInfoContainer.snp.makeConstraints { make in
      make.height.greaterThanOrEqualTo(120)
    }
  }
  
  private func setupActivityIndicatorContainerView() {
    addSubview(activityIndicatorContainerView)
    activityIndicatorContainerView.backgroundColor = .white
    activityIndicatorContainerView.isHidden = true
    activityIndicatorContainerView.layer.cornerRadius = 24
    activityIndicatorContainerView.layer.cornerCurve = .continuous
    activityIndicatorContainerView.snp.makeConstraints { make in
      make.edges.equalTo(profileInfoContainer)
    }
  }
  
  private func makeAuthView() {
    profileInfoContainer.isHidden = false
    profileInfoContainer.addArrangedSubview(authView)
    updateLayout()
  }
  
  private func makeDirections(_ directions: [RatingDirection]) {
    profileInfoContainer.isHidden = false
    
    var maxWidth: CGFloat = 0
    
    directions.forEach {
      if let place = $0.place {
        let stringWidth = String(place).width(withConstrainedHeight: 32, font: .Bold.header3 ?? .boldSystemFont(ofSize: 20))
        maxWidth = maxWidth < stringWidth ? stringWidth : maxWidth
      }
    }
    
    directions.enumerated().forEach { element in
      let directionView = DirectionView(with: element.element, labelWidth: maxWidth)
      self.profileInfoContainer.addArrangedSubview(directionView)
      if let nextElement = directions.element(at: element.offset + 1), nextElement.priority == 1, element.element.priority == 1 {
        profileInfoContainer.setCustomSpacing(0, after: directionView)
      }
    }
    updateLayout()
  }
  
  private func makeName(_ name: String?) {
    guard let name = name else {
      nameLabel.isHidden = true
      nameLabel.text = ""
      updateLayout()
      return
    }
    nameLabel.isHidden = false
    nameLabel.text = Localizable.Profile.hello(name)
    updateLayout()
  }
  
  private func updateLayout() {
    UIView.animate(withDuration: 0.3) {
      self.profileInfoContainer.layoutIfNeeded()
      self.onDidUpdate?()
    }
  }
}
