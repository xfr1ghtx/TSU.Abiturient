//
//  UpcommingEventsView.swift
//  TSUAbiturient
//

import UIKit

final class UpcommingEventsView: UIView, DataLoadingView, ActivityIndicatorViewDisplaying, ErrorHandling {
  // MARK: - Properties
  
  var activityIndicatorView = UIActivityIndicatorView()
  
  private let titleLabel = Label(textStyle: .header3)
  private let allButton = UIButton(type: .system)
  private let scrollView = UIScrollView()
  private let scrollContentView = UIView()
  private let cardContainerStackView = UIStackView()
  
  private var viewModel: UpcommingEventsViewModel?
  
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
  
  func configure(with viewModel: UpcommingEventsViewModel) {
    self.viewModel = viewModel
    bind(to: viewModel)
    viewModel.loadData()
  }
  
  // MARK: - Public methods
  
  func handleRequestStarted() {}
  
  func handleRequestFinished() {}
  
  func handleErrorReceived() {}
  
  func reloadData() {
    cardContainerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    guard var events = viewModel?.events else { return }
    events = Array(events.prefix(Constants.eventsShowsOnMainScreen))
    
    guard events.count > 1 else {
      guard let event = events.element(at: 0) else {
        return
      }
              
      let cardView = UpcommingEventCard(with: event)
      cardView.onDidTap = { [weak self] event in
        guard let self = self else { return }
        self.viewModel?.didTapOnCardWith(event: event)
      }
      cardContainerStackView.addArrangedSubview(cardView)
      cardView.snp.makeConstraints { make in
        make.width.equalTo(scrollView.snp.width).inset(16)
        make.height.equalToSuperview()
      }
      return
    }
    
    events.forEach {
      let cardView = UpcommingEventCard(with: $0)
      cardView.onDidTap = { [weak self] event in
        guard let self = self else { return }
        self.viewModel?.didTapOnCardWith(event: event)
      }
      cardContainerStackView.addArrangedSubview(cardView)
      cardView.snp.makeConstraints { make in
        make.width.equalTo(192)
        make.height.equalToSuperview()
      }
    }
  }
  
  // MARK: - Actions
  
  @objc
  private func tapOnView() {
    viewModel?.didTapOnView()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupView()
    setupTitleLabel()
    setupAllButton()
    setupScrollView()
    setupCardContainerStackView()
    setupActivityIndicatorView()
  }
  
  private func setupView() {
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnView)))
    layer.backgroundColor = UIColor.Light.Surface.primary.cgColor
    layer.cornerRadius = 24
    layer.cornerCurve = .continuous
    addShadow(offset: CGSize(width: 0, height: 8), radius: 12, color: .Light.Global.black, opacity: 0.08)
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.textColor = .Light.Text.primary
    titleLabel.text = Localizable.UpcommingEvents.Component.title
    titleLabel.textAlignment = .left

    titleLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().inset(16)
    }
  }
  
  private func setupAllButton() {
    addSubview(allButton)
    
    allButton.setTitle(Localizable.UpcommingEvents.Component.AllButton.title, for: .normal)
    allButton.setImage(Assets.Images.chevronRight.image.withRenderingMode(.alwaysTemplate), for: .normal)
    allButton.addTarget(self, action: #selector(tapOnView), for: .touchUpInside)
    allButton.titleLabel?.font = .Regular.body
    allButton.tintColor = .Light.Icons.accent
    allButton.setTitleColor(.Light.Text.accent, for: .normal)
    allButton.semanticContentAttribute = .forceRightToLeft
    
    allButton.snp.makeConstraints { make in
      make.top.trailing.equalToSuperview().inset(16)
      make.height.equalTo(20)
    }
  }
  
  private func setupScrollView() {
    addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview().inset(16)
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.height.equalTo(96)
    }
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    scrollView.showsHorizontalScrollIndicator = false
    
    scrollView.addSubview(scrollContentView)
    scrollContentView.layer.masksToBounds = true
    scrollContentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
  }
  private func setupCardContainerStackView() {
    scrollContentView.addSubview(cardContainerStackView)
    cardContainerStackView.axis = .horizontal
    cardContainerStackView.alignment = .fill
    cardContainerStackView.spacing = 8
    cardContainerStackView.distribution = .fillEqually
    cardContainerStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
