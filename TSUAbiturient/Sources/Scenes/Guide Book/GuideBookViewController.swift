//
//  GuideBookViewController.swift
//  TSUAbiturient
//

import Foundation
import UIKit
import Kingfisher

final class GuideBookViewController: BaseViewController, DataLoadingView,
                                      ActivityIndicatorViewDisplaying, EmptyStateErrorViewDisplaying,
                                      ErrorHandling, NavigationBarHiding {

  // MARK: - Properties
  
  let activityIndicatorView = UIActivityIndicatorView()
  let emptyStateErrorView = EmptyStateErrorView()
  
  let titleLabel = Label(textStyle: .header1)
  let scrollContainerView = UIScrollView()
  let stackContainerView = UIStackView()
  
  let facultyCardView = UIView()
  let facultyImageView = UIImageView()
  let facultyGradientView = UIView()
  let facultyGradientLayer = CAGradientLayer()
  let facultyNameLabel = Label(textStyle: .bodyBold)
  let facultyTaglineLabel = Label(textStyle: .body)
  let facultyMeetLabel = Label(textStyle: .bodyBold)
  let facultySelectLabel = Label(textStyle: .body)
  
  let centerView = UIView()
  let calculatorCardView = UIView()
  let calculatorLabel = Label(textStyle: .bodyBold)
  let calculatorImageView = UIImageView()
  
  let mapCardView = UIView()
  let mapLabel = Label(textStyle: .bodyBold)
  let mapGradientLayer = CAGradientLayer()
  let mapImageView = UIImageView()
  
  let trainSessionCardView = UIView()
  
  private var changeFacultyTimer: Timer?
  
  private let viewModel: GuideBookViewModel
  
  // MARK: - Init
  
  init(viewModel: GuideBookViewModel) {
    self.viewModel = viewModel
   super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("GuideBookViewController init(coder:) has not been implemented")
  }
  
  // MARK: - Actions
  
  @objc private func didTapFaculty() {
    viewModel.didSelectFacultyCard()
  }
  
  @objc private func didTapCalculator() {
    viewModel.didSelectCalculatorCard()
  }
  
  @objc private func didTapMap() {
    viewModel.didSelectMapCard()
  }
  
  @objc private func fireChangeFacultyTimer() {
    viewModel.changeFaculty()
    configureFacultyCard()
  }
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    changeFacultyTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self,
                                              selector: #selector(fireChangeFacultyTimer), userInfo: nil,
                                              repeats: true)
    setup()
    bind(to: viewModel)
    viewModel.viewIsReady()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.mapGradientLayer.frame = self.mapCardView.bounds
    self.facultyGradientLayer.frame = self.facultyGradientView.bounds
  }
  
  deinit {
    changeFacultyTimer?.invalidate()
  }
  
  // MARK: - Public methods
  
  func handleRequestStarted() {
    scrollContainerView.isHidden = true
  }
  
  func handleRequestFinished() {
    configureFacultyCard()
    scrollContainerView.isHidden = false
  }
  
  func handleErrorReceived() {
    scrollContainerView.isHidden = true
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainers()
    setupActivityIndicatorView()
    setupEmptyStateErrorView()
  }
  
  private func setupContainers() {
    view.addSubview(scrollContainerView)
    scrollContainerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    scrollContainerView.addSubview(stackContainerView)
    stackContainerView.snp.makeConstraints { make in
      make.top.equalTo(scrollContainerView.safeAreaLayoutGuide.snp.top).inset(16)
      make.horizontalEdges.equalTo(scrollContainerView.safeAreaLayoutGuide.snp.horizontalEdges).inset(16)
      make.width.equalTo(scrollContainerView.frameLayoutGuide.snp.width).offset(-32)
    }
    stackContainerView.axis = .vertical
    stackContainerView.alignment = .fill
    stackContainerView.distribution = .equalSpacing
    stackContainerView.spacing = 16
    
    setupTitle()
    setupFacultyWhiteCard()
    setupButtonsBlock()
    setupTrainSessionCard()
  }
  
  private func setupTitle() {
    stackContainerView.addArrangedSubview(titleLabel)
    titleLabel.text = Localizable.GuideBook.title
    titleLabel.snp.makeConstraints { make in
      make.height.equalTo(40)
    }
  }
  
  private func setupFacultyWhiteCard() {
    stackContainerView.addArrangedSubview(facultyCardView)
    stackContainerView.setCustomSpacing(24, after: facultyCardView)
    
    setupWhiteCardView()
    setupFacultyImageCard()
    setupWhiteCardTitle()
    setupWhiteCardSubtitle()
  }
  
  private func setupFacultyImageCard() {
    setupFacultyImage()
    setupFacultyGradient()
    setupFacultySlogan()
    setupFacultyName()
  }
  
  private func setupFacultyImage() {
    facultyCardView.addSubview(facultyImageView)
    facultyImageView.layer.cornerRadius = 24
    facultyImageView.layer.cornerCurve = .continuous
    facultyImageView.contentMode = .scaleAspectFill
    facultyImageView.clipsToBounds = true
    facultyImageView.snp.makeConstraints { make in
      make.horizontalEdges.top.equalToSuperview()
      make.height.equalTo(168)
    }
  }
  
  private func setupFacultyGradient() {
    facultyCardView.addSubview(facultyGradientView)
    facultyGradientView.layer.cornerRadius = 24
    facultyGradientView.layer.cornerCurve = .continuous
    facultyGradientView.clipsToBounds = true
    facultyGradientView.snp.makeConstraints { make in
      make.edges.equalTo(facultyImageView.snp.edges)
    }
    
    facultyGradientLayer.colors = [UIColor.Gradient.blackFullTransparent.cgColor, UIColor.Gradient.black.cgColor]
    facultyGradientLayer.startPoint = CGPoint(x: 0, y: 0)
    facultyGradientLayer.endPoint = CGPoint(x: 0, y: 1)
    facultyGradientView.layer.insertSublayer(facultyGradientLayer, at: 0)
  }
  
  private func setupFacultySlogan() {
    facultyCardView.addSubview(facultyTaglineLabel)
    facultyTaglineLabel.textColor = .Light.Text.white
    facultyTaglineLabel.numberOfLines = 0
    facultyTaglineLabel.lineBreakMode = .byWordWrapping
    facultyTaglineLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(16)
      make.bottom.equalTo(facultyImageView.snp.bottom).inset(16)
    }
  }
  
  private func setupFacultyName() {
    facultyCardView.addSubview(facultyNameLabel)
    facultyNameLabel.textColor = .Light.Text.white
    facultyNameLabel.numberOfLines = 0
    facultyNameLabel.lineBreakMode = .byWordWrapping
    facultyNameLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(16)
      make.bottom.equalTo(facultyTaglineLabel.snp.top).inset(-4)
    }
  }
  
  private func setupWhiteCardView() {
    facultyCardView.backgroundColor = .Light.Surface.primary
    facultyCardView.layer.cornerRadius = 24
    facultyCardView.layer.cornerCurve = .continuous
    facultyCardView.addShadow(offset: CGSize(width: 0, height: 12), radius: 24, color: .Light.Global.black, opacity: 0.08)
    facultyCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFaculty)))
  }
  
  private func setupWhiteCardTitle() {
    facultyCardView.addSubview(facultyMeetLabel)
    facultyMeetLabel.text = Localizable.GuideBook.FacultyCard.title
    facultyMeetLabel.textColor = .Light.Text.primary
    facultyMeetLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(16)
      make.top.equalTo(facultyImageView.snp.bottom).offset(16)
    }
  }
  
  private func setupWhiteCardSubtitle() {
    facultyCardView.addSubview(facultySelectLabel)
    facultySelectLabel.text = Localizable.GuideBook.FacultyCard.subtitle
    facultySelectLabel.textColor = .Light.Text.tertiary
    facultySelectLabel.snp.makeConstraints { make in
      make.horizontalEdges.bottom.equalToSuperview().inset(16)
      make.top.equalTo(facultyMeetLabel.snp.bottom).offset(4)
    }
  }
  
  private func setupButtonsBlock() {
    stackContainerView.addArrangedSubview(centerView)
    centerView.snp.makeConstraints { make in
      make.height.equalTo(88)
    }
    
    setupCalculatorCard()
    setupMapCard()
  }
  
  private func setupCalculatorCard() {
    setupCalculatorCardView()
    setupCalculatorImage()
    setupCalculatorTitle()
  }
  
  private func setupMapCard() {
    setupMapCardView()
    setupMapImageView()
    setupMapGradient()
    setupMapTitle()
  }
  
  private func setupTrainSessionCard() {
    // TODO: add
    
  }
  
  private func setupCalculatorCardView() {
    centerView.addSubview(calculatorCardView)
    calculatorCardView.backgroundColor = .Light.Surface.primary
    calculatorCardView.layer.cornerRadius = 24
    calculatorCardView.layer.cornerCurve = .continuous
    calculatorCardView.addShadow(offset: CGSize(width: 0, height: 12), radius: 24, color: .Light.Global.black, opacity: 0.08)
    calculatorCardView.snp.makeConstraints { make in
      make.leading.verticalEdges.equalToSuperview()
    }
    calculatorCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCalculator)))
  }
  
  private func setupCalculatorImage() {
    calculatorCardView.addSubview(calculatorImageView)
    calculatorImageView.image = Assets.Images.calculator.image
    calculatorImageView.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().inset(16)
      make.size.equalTo(32)
    }
  }
  
  private func setupCalculatorTitle() {
    calculatorCardView.addSubview(calculatorLabel)
    calculatorLabel.text = Localizable.GuideBook.CalculatorCard.title
    calculatorLabel.textColor = .Light.Text.primary
    calculatorLabel.snp.makeConstraints { make in
      make.leading.bottom.equalToSuperview().inset(16)
    }
  }
  
  private func setupMapCardView() {
    centerView.addSubview(mapCardView)
    mapCardView.layer.cornerRadius = 24
    mapCardView.layer.cornerCurve = .continuous
    mapCardView.addShadow(offset: CGSize(width: 0, height: 12), radius: 24, color: .Light.Global.black, opacity: 0.08)
    mapCardView.clipsToBounds = true
    
    mapCardView.snp.makeConstraints { make in
      make.leading.equalTo(calculatorCardView.snp.trailing).offset(16)
      make.trailing.verticalEdges.equalToSuperview()
      make.width.equalTo(calculatorCardView.snp.width)
    }
    mapCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMap)))
  }
  
  private func setupMapImageView() {
    mapCardView.addSubview(mapImageView)
    mapImageView.image = Assets.Images.map.image
    mapImageView.contentMode = .scaleAspectFill
    mapImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupMapGradient() {
    mapGradientLayer.colors = [UIColor.Gradient.blackFullTransparent.cgColor, UIColor.Gradient.black.cgColor]
    mapGradientLayer.startPoint = CGPoint(x: 0, y: 0)
    mapGradientLayer.endPoint = CGPoint(x: 0, y: 1)
    mapCardView.layer.insertSublayer(mapGradientLayer, at: 1)
  }
  
  private func setupMapTitle() {
    mapCardView.addSubview(mapLabel)
    mapLabel.text = Localizable.GuideBook.Map.title
    mapLabel.textColor = .Light.Text.white
    mapLabel.snp.makeConstraints { make in
      make.leading.bottom.equalToSuperview().inset(16)
    }
  }
  
  private func configureFacultyCard() {
    UIView.transition(with: facultyNameLabel, duration: 0.5,
                      options: .transitionCrossDissolve) { [weak self] in
      self?.facultyNameLabel.text = self?.viewModel.facultyTitle }
    
    UIView.transition(with: facultyTaglineLabel, duration: 0.5,
                      options: .transitionCrossDissolve) { [weak self] in
      self?.facultyTaglineLabel.text = self?.viewModel.facultyTagline }
    
    facultyImageView.setImage(with: viewModel.facultyImageURL, placeholder: nil, options:
                                [.transition(ImageTransition.fade(0.5)),
                                .forceTransition,
                                 .keepCurrentImageWhileLoading
                                ])
  }
}
