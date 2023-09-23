//
//  ProgramListItemView.swift
//  TSUAbiturient
//

import Foundation
import UIKit

typealias ProgramListItemCell = TableCellContainer<ProgramListItemView>

class ProgramListItemView: UIView, Configurable {
  // MARK: - Properties
  
  private let priorityLabel = Label(textStyle: .bodyBold)
  private let specialtyLabel = Label(textStyle: .bodyBold)
  private let facultyLabel = Label(textStyle: .footnote)
  
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
  
  func configure(with viewModel: ProgramListItemViewModel) {
    priorityLabel.text = viewModel.priority
    specialtyLabel.text = viewModel.title
    facultyLabel.text = viewModel.faculty
 }
  
  // MARK: - Setup
  
  private func setup() {
    addSubview(priorityLabel)
    priorityLabel.backgroundColor = UIColor.Light.Surface.secondary
    priorityLabel.layer.cornerRadius = 4
    priorityLabel.layer.cornerCurve = .continuous
    priorityLabel.textAlignment = .center
    priorityLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
      make.size.equalTo(32)
    }
    
    addSubview(specialtyLabel)
    specialtyLabel.numberOfLines = 0
    specialtyLabel.lineBreakMode = .byWordWrapping
    specialtyLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.leading.equalTo(priorityLabel.snp.trailing).offset(8)
      make.trailing.equalToSuperview()
    }
    
    addSubview(facultyLabel)
    facultyLabel.numberOfLines = 0
    facultyLabel.lineBreakMode = .byWordWrapping
    facultyLabel.textColor = UIColor.Light.Text.secondary
    facultyLabel.snp.makeConstraints { make in
      make.top.equalTo(specialtyLabel.snp.bottom).offset(4)
      make.leading.equalTo(priorityLabel.snp.trailing).offset(8)
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview().inset(8)
    }
  }
}
