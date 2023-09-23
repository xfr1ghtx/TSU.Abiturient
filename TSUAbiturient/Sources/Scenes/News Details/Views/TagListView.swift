//
//  TagListView.swift
//  TSUAbiturient
//

import UIKit

final class TagListView: UIView {
  // MARK: - Properties
  
  private let scrollView = UIScrollView()
  private let stackViewContainer = UIStackView()
  
  // MARK: - Inits
  
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Configure
  
  func configure(with tags: [NewsTag]) {
    stackViewContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    tags.forEach {
      let view = TagView(withText: $0.text)
      stackViewContainer.addArrangedSubview(view)
    }
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupScrollView()
    setupStackViewContainer()
  }
  
  private func setupScrollView() {
    addSubview(scrollView)
    
    scrollView.showsHorizontalScrollIndicator = false
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupStackViewContainer() {
    scrollView.addSubview(stackViewContainer)
    
    stackViewContainer.axis = .horizontal
    stackViewContainer.spacing = 8
    stackViewContainer.distribution = .fill
    
    stackViewContainer.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(24)
      make.verticalEdges.equalToSuperview()
    }
  }
}
