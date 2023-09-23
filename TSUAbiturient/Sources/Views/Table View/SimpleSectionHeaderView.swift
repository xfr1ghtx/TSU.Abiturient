//
//  SimpleSectionHeaderView.swift
//  TSUAbiturient
//

import UIKit

typealias SimpleSectionHeader = TableHeaderFooterContainer<SimpleSectionHeaderView>

final class SimpleSectionHeaderView: UIView, Configurable {
  // MARK: - Properties
  
  private let titleLabel = Label(textStyle: .header2)
  
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
  
  func configure(with viewModel: SimpleSectionHeaderViewModel) {
    self.titleLabel.text = viewModel.title
  }
  
  // MARK: - Setup
  
  private func setup() {
    addSubview(titleLabel)
    titleLabel.textColor = .Light.Text.primary
    titleLabel.numberOfLines = 0
    
    titleLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

extension SimpleSectionHeaderView: PaddingsDescribing {
  var paddings: UIEdgeInsets {
    return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  }
}
