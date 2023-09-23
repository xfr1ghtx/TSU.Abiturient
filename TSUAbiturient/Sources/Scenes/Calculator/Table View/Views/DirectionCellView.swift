//
//  DirectionCellView.swift
//  TSUAbiturient
//

import UIKit

typealias DirectionCell = TableCellContainer<DirectionCellView>

final class DirectionCellView: UIView, Configurable {
  // MARK: - Properties
  
  private let verticalStackView = UIStackView()
  private let horizontalTagsStackView = UIStackView()
  private let scrollView = UIScrollView()
  private let directionLabel = Label(textStyle: .bodyBold)
  private let facultyLabel = Label(textStyle: .footnote)
  private let descriptionLabel = Label(textStyle: .body)
  
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
  
  func configure(with viewModel: DirectionCellViewModel) {
    directionLabel.text = nil
    facultyLabel.text = nil
    descriptionLabel.text = nil
    horizontalTagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
   
    directionLabel.text = viewModel.directionTitle
    facultyLabel.text = viewModel.facultySubTitle
    
    descriptionLabel.attributedText = NSAttributedString(html: viewModel.description)
    descriptionLabel.font = TextStyle.body.font
    
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2

    let years = viewModel.period
    
    let formattedYears = formatter.number(from: years)
    guard let currentFormattedYears = formattedYears else { return }
    let yearsString = Localizable.Plurals.formattedYears(currentFormattedYears, Float(years) ?? 0.0)

    horizontalTagsStackView.addArrangedSubview(TagView(withText: viewModel.educationForm))
    horizontalTagsStackView.addArrangedSubview(TagView(withText: yearsString))
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupStackView()
    setupDirectionTitle()
    setupFacultyLabel()
    setupDescriptionLabel()
    setupScrollView()
    setupTagsStackView()
  }
  
  private func setupContainer() {
    backgroundColor = .Light.Surface.primary
    layer.cornerRadius = 24
    layer.cornerCurve = .continuous
    addShadow(offset: CGSize(width: 0, height: 8), radius: 4, color: .Light.Global.black, opacity: 0.08)
  }
  
  private func setupStackView() {
    addSubview(verticalStackView)
    verticalStackView.axis = .vertical
    verticalStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(16)
    }
  }
  
  private func setupDirectionTitle() {
    directionLabel.textColor = .Light.Text.primary
    directionLabel.numberOfLines = 0
    verticalStackView.addArrangedSubview(directionLabel)
  }
  
  private func setupFacultyLabel() {
    facultyLabel.textColor = .Light.Text.secondary
    facultyLabel.lineBreakMode = .byTruncatingTail
    facultyLabel.numberOfLines = 0
    verticalStackView.addArrangedSubview(facultyLabel)
    verticalStackView.setCustomSpacing(8, after: facultyLabel)
  }
  
  private func setupDescriptionLabel() {
    descriptionLabel.textColor = .Light.Text.primary
    descriptionLabel.numberOfLines = 3
    descriptionLabel.lineBreakMode = .byTruncatingTail
    descriptionLabel.textAlignment = .left
    descriptionLabel.sizeToFit()
    verticalStackView.addArrangedSubview(descriptionLabel)
    
    descriptionLabel.snp.makeConstraints { make in
      make.width.equalToSuperview()
    }
    verticalStackView.setCustomSpacing(8, after: descriptionLabel)
  }
  
  private func setupScrollView() {
    verticalStackView.addArrangedSubview(scrollView)
    scrollView.showsHorizontalScrollIndicator = false
    
    scrollView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
      make.height.equalTo(24)
    }
  }
  
  private func setupTagsStackView() {
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

extension DirectionCellView: PaddingsDescribing {
  var paddings: UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
  }
}
