//
//  DirectionDetailsViewController.swift
//  TSUAbiturient
//

import UIKit

final class DirectionDetailsViewController: BaseViewController {
  // MARK: - Properties
  
  private let viewModel: DirectionDetailsViewModel
  
  private var titleStackView = UIStackView()
  private var directionTitleLabel = Label(textStyle: .header2)
  private var directionDescriptionLabel = Label(textStyle: .smallFootnote)
  private var shortDescriptionDirectionLabel = Label(textStyle: .smallFootnote)
  
  private var scrollView = UIScrollView()
  private var directionDetailsView = UIView()
  
  private var tagsScrollView = UIScrollView()
  private var horizontalTagsStackView = UIStackView()
  
  private var contentStackView = UIStackView()
  
  private var detailsCardStackView = UIStackView()
  
  private var descriptionOfDirectionLabel = Label(textStyle: .body)
  
  private var entranceTestsStackView = UIStackView()
  private var entranceTestsTitleLabel = Label(textStyle: .bodyBold)
  
  private var entranceRequiredStackView = UIStackView()
  private var entranceRequiredTestLabels = Label(textStyle: .smallFootnote)
  private var entranceRequiredListSubjects = Label(textStyle: .body)
  
  private var entranceOptionalStackView = UIStackView()
  private var entranceOptionalTestLabels = Label(textStyle: .smallFootnote)
  private var entranceOptionalListSubjects = Label(textStyle: .body)
  
  private var passingScoreStackView = UIStackView()
  private var passingScoreTitleLabel = Label(textStyle: .bodyBold)
  private var passingScoreCountLabel = Label(textStyle: .body)
  
  private var costStackView = UIStackView()
  private var costTitleLabel = Label(textStyle: .bodyBold)
  private var costCountLabel = Label(textStyle: .body)
  
  // MARK: - Init
  
  init(viewModel: DirectionDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupScrollView()
    setupHeaderStackView()
    setupTagsView()
    setupContentStackView()
    setupCardStackView()
    setupDescriptionDirectionLabel()
    setupEntranceTestsStackView()
    
    if !viewModel.entranceRequiredListSubjectsLabel.isEmpty {
      setupEntranceRequiredStackView()
    }
   
    if !viewModel.entranceOptionalListSubjectsLabel.isEmpty {
      setupEntranceOptionalStackView()
    }
    
    setupPassingScoreStackView()
    setupCostStackView()
  }
  
  private func setupScrollView() {
    scrollView.showsVerticalScrollIndicator = false
    scrollView.bounces = false
    view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    scrollView.addSubview(directionDetailsView)
    
    directionDetailsView.snp.makeConstraints { make in
      make.horizontalEdges.top.equalToSuperview()
      make.bottom.equalToSuperview().inset(16)
      make.width.equalToSuperview()
    }
  }
  
  private func setupHeaderStackView() {
    titleStackView.axis = .vertical
    titleStackView.spacing = 4
    
    directionDetailsView.addSubview(titleStackView)
    
    titleStackView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalToSuperview().inset(16)
    }
    
    directionTitleLabel.text = viewModel.directionNameTitle
    directionTitleLabel.numberOfLines = 0
    
    titleStackView.addArrangedSubview(directionTitleLabel)
    
    directionDescriptionLabel.text = viewModel.directionDescriptionTitle
    directionDescriptionLabel.numberOfLines = 0
    
    titleStackView.addArrangedSubview(directionDescriptionLabel)
    
    shortDescriptionDirectionLabel.text = viewModel.shortDescriptionDirectionLabel
    shortDescriptionDirectionLabel.numberOfLines = 0
    shortDescriptionDirectionLabel.textColor = .Light.Text.secondary

    titleStackView.addArrangedSubview(shortDescriptionDirectionLabel)
  }
  
  private func setupTagsView() {
    directionDetailsView.addSubview(tagsScrollView)
    
    tagsScrollView.snp.makeConstraints { make in
      make.top.equalTo(titleStackView.snp.bottom).inset(-16)
      make.horizontalEdges.equalToSuperview().inset(16)
      make.height.equalTo(24)
    }
    
    tagsScrollView.addSubview(horizontalTagsStackView)
    
    horizontalTagsStackView.axis = .horizontal
    horizontalTagsStackView.spacing = 8
    horizontalTagsStackView.distribution = .fill
    
    horizontalTagsStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    horizontalTagsStackView.addArrangedSubview(TagView(withText: viewModel.lavelTagsName))
    horizontalTagsStackView.addArrangedSubview(TagView(withText: viewModel.educationFormTagsName))
    horizontalTagsStackView.addArrangedSubview(TagView(withText: viewModel.periodTagsName))
  }
  
  private func setupContentStackView() {
    contentStackView.axis = .vertical
    contentStackView.spacing = 24
    directionDetailsView.addSubview(contentStackView)
    
    contentStackView.snp.makeConstraints { make in
      make.top.equalTo(tagsScrollView.snp.bottom).inset(-24)
      make.horizontalEdges.equalToSuperview().inset(16)
      make.bottom.equalTo(directionDetailsView.snp.bottom)
    }
  }
  
  private func setupCardStackView() {
    detailsCardStackView.axis = .horizontal
    detailsCardStackView.spacing = 8
    detailsCardStackView.distribution = .fillEqually
    
    contentStackView.addArrangedSubview(detailsCardStackView)
    
    detailsCardStackView.addArrangedSubview(DetailsCard(titleText: Localizable.Calculator.freePlaces,
                                                        countText: viewModel.budgetCountValue))
    detailsCardStackView.addArrangedSubview(DetailsCard(titleText: Localizable.Calculator.paidPlaces,
                                                        countText: viewModel.paidCountValue))
  }
  
  private func setupDescriptionDirectionLabel() {
    descriptionOfDirectionLabel.numberOfLines = 0
    contentStackView.addArrangedSubview(descriptionOfDirectionLabel)
    
    descriptionOfDirectionLabel.text = viewModel.descriptionOfDirectionLabel
  }
  
  private func setupEntranceTestsStackView() {
    entranceTestsStackView.axis = .vertical
    entranceTestsStackView.spacing = 8
    
    contentStackView.addArrangedSubview(entranceTestsStackView)
    
    entranceTestsTitleLabel.text = Localizable.Calculator.entranceTests
    entranceTestsStackView.addArrangedSubview(entranceTestsTitleLabel)
  }
  
  private func setupEntranceRequiredStackView() {
    entranceRequiredStackView.axis = .vertical
    entranceRequiredStackView.spacing = 2
    
    entranceTestsStackView.addArrangedSubview(entranceRequiredStackView)
    
    entranceRequiredTestLabels.text = Localizable.Calculator.requiredSubjects
    entranceRequiredTestLabels.textColor = .Light.Text.secondary
    entranceRequiredStackView.addArrangedSubview(entranceRequiredTestLabels)
    
    entranceRequiredListSubjects.text = viewModel.entranceRequiredListSubjectsLabel
    entranceRequiredListSubjects.numberOfLines = 0
    entranceRequiredStackView.addArrangedSubview(entranceRequiredListSubjects)
  }
  
  private func setupEntranceOptionalStackView() {
    entranceOptionalStackView.axis = .vertical
    entranceOptionalStackView.spacing = 2
    
    entranceTestsStackView.addArrangedSubview(entranceOptionalStackView)
    
    entranceOptionalTestLabels.text = Localizable.Calculator.choiceSubjects
    entranceOptionalTestLabels.textColor = .Light.Text.secondary
    entranceOptionalStackView.addArrangedSubview(entranceOptionalTestLabels)
    
    entranceOptionalListSubjects.text = viewModel.entranceOptionalListSubjectsLabel
    entranceOptionalListSubjects.numberOfLines = 0
    entranceOptionalStackView.addArrangedSubview(entranceOptionalListSubjects)
  }
  
  private func setupPassingScoreStackView() {
    passingScoreStackView.axis = .vertical
    passingScoreStackView.spacing = 8
    
    contentStackView.addArrangedSubview(passingScoreStackView)
  
    passingScoreTitleLabel.text = Localizable.Calculator.passingScore
    passingScoreStackView.addArrangedSubview(passingScoreTitleLabel)
    
    passingScoreCountLabel.text = viewModel.passingScoreCountLabel
    passingScoreStackView.addArrangedSubview(passingScoreCountLabel)
  }
  
  private func setupCostStackView() {
    costStackView.axis = .vertical
    costStackView.spacing = 8
    
    contentStackView.addArrangedSubview(costStackView)
    
    costTitleLabel.text = Localizable.Calculator.costOfStudy
    costStackView.addArrangedSubview(costTitleLabel)
    
    costCountLabel.text = viewModel.costOfStudyCountLabel
    costStackView.addArrangedSubview(costCountLabel)
  }
}
