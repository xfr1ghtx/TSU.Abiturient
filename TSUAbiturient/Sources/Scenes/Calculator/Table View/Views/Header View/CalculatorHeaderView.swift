//
//  CalculatorHeaderView.swift
//  TSUAbiturient
//

import UIKit

typealias CalculatorHeader = TableHeaderFooterContainer<CalculatorHeaderView>

final class CalculatorHeaderView: UIView, Configurable {
  // MARK: - Properties

  var onDidTapToAddSubjects: (() -> Void)?
  
  private let calculatorHatImageView = UIImageView()
  private let headerStackView = UIStackView()
  private let horizontalTagsStackView = UIStackView()
  private let subjectsListLabel = Label(textStyle: .footnote)
  private let chooseSubjectsLabel = Label(textStyle: .bodyBold)
  private let subjectsStackView = UIStackView()
  
  private let scrollView = UIScrollView()
  
  private let titleStackView = UIStackView()
  
  // MARK: - Init
  
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Configuration
  
  func configure(with viewModel: CalculatorHeaderViewModel) {
    chooseSubjectsLabel.text = viewModel.title
    subjectsListLabel.text = ""
    calculatorHatImageView.image = Assets.Images.universityHat.image
    
    viewModel.updateSubjectsListData = { [weak self] subjectList in
      self?.subjectsListLabel.text = subjectList
      viewModel.onDidUpdateHeaderViewClosure?()
      self?.updateConstraints()
    }
    
    EducationFormListSections.allCases.forEach { form in
      let tagView = CalculatorTagView(withText: form.educationFormTitle, isTagClickable: true)
      
      tagView.onDidTapToTag = {
        viewModel.filterDirectionsList(educationType: form, tagType: tagView.tagSelectionState, headerHeight: self.bounds.height)
      }
      
      horizontalTagsStackView.addArrangedSubview(tagView)
    }
    
    onDidTapToAddSubjects = {
      viewModel.onDidUpdateDirectionsSelectionViewClosure?()
      viewModel.onDidTapOnTitle?()
    }
  }
  
  // MARK: - Set tapGestureRecognizer
  
  @objc private func tapOnLabel() {
    onDidTapToAddSubjects?()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupHeaderStackView()
    setupSubjectsStackView()
    setupTitleStackView()
    setupSubjectsList()
    setupEducationTagsScrollView()
    setupHorizontalStackView()
  }
  
  private func setupHeaderStackView() {
    addSubview(headerStackView)
    headerStackView.axis = .vertical
    headerStackView.alignment = .fill
    headerStackView.spacing = 18
    
    headerStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupSubjectsStackView() {
    subjectsStackView.axis = .vertical
    subjectsStackView.alignment = .fill
    headerStackView.addArrangedSubview(subjectsStackView)
    
    subjectsStackView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalToSuperview()
    }
  }
  
  private func setupTitleStackView() {
    titleStackView.axis = .horizontal
    titleStackView.spacing = 8
    
    subjectsStackView.addArrangedSubview(titleStackView)
  
    titleStackView.snp.makeConstraints { make in
      make.horizontalEdges.top.equalToSuperview()
    }
    
    calculatorHatImageView.contentMode = .scaleAspectFit
    calculatorHatImageView.clipsToBounds = true
      
    titleStackView.addArrangedSubview(calculatorHatImageView)
    
    chooseSubjectsLabel.textColor = .Light.Text.accent
    chooseSubjectsLabel.isUserInteractionEnabled = true
      
    let labelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnLabel))
    chooseSubjectsLabel.addGestureRecognizer(labelGestureRecognizer)
    titleStackView.addArrangedSubview(chooseSubjectsLabel)
    
    let spacerView = UIView()
    titleStackView.addArrangedSubview(spacerView)

    spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
  }
  
  private func setupSubjectsList() {
    subjectsListLabel.textColor = .Light.Text.secondary
    subjectsListLabel.numberOfLines = 0
       
    subjectsStackView.addArrangedSubview(subjectsListLabel)
    
    subjectsListLabel.snp.makeConstraints { make in
      make.leading.equalTo(32)
    }
  }

  private func setupEducationTagsScrollView() {
    headerStackView.addArrangedSubview(scrollView)
    scrollView.isScrollEnabled = false
    scrollView.showsHorizontalScrollIndicator = false
      
    scrollView.snp.makeConstraints { make in
      make.horizontalEdges.bottom.equalToSuperview()
      make.height.equalTo(24)
    }
  }
  
  private func updateSubjectsLabel() {
  }

  private func setupHorizontalStackView() {
    scrollView.addSubview(horizontalTagsStackView)
      
    horizontalTagsStackView.axis = .horizontal
    horizontalTagsStackView.spacing = 8
    horizontalTagsStackView.distribution = .fill
      
    horizontalTagsStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

// MARK: - PaddingDescribing

extension CalculatorHeaderView: PaddingsDescribing {
  var paddings: UIEdgeInsets {
    return UIEdgeInsets(top: 18, left: 16, bottom: 24, right: 16)
  }
}
