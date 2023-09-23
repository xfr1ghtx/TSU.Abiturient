//
//  DisciplineTableCellView.swift
//  TSUAbiturient
//

import UIKit

protocol DisciplineTableCellViewDelegate: AnyObject {
  func changeScoreTextInTextField(with textField: UITextField)
  func changeCheckMarkViewWithTextField(with textField: UITextField) -> Bool
}

typealias DisciplineCell = TableCellContainer<DisciplineTableCellView>

class DisciplineTableCellView: UIView, Configurable {
  // MARK: - Properties
  
  private let scoreTextField = TextField()
  private let subjectLabel = Label(textStyle: .body)
  private let subjectCheckMark = UIImageView()
  private let subjectStackView = UIStackView()
  private let subjectWithScoreStackView = UIStackView()
  
  weak var delegate: DisciplineTableCellViewDelegate?
  
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
  
  func configure(with viewModel: DisciplineTableCellViewModel) {
    subjectLabel.text = nil
    scoreTextField.text = nil
    subjectCheckMark.alpha = viewModel.isSubjectSelected ? 1 : 0
    
    delegate = viewModel
  
    scoreTextField.textField.addTarget(self, action: #selector(changeScoreTextInTextField), for: .editingChanged)
    scoreTextField.textField.addTarget(self, action: #selector(changeMarkViewWithTextField), for: .editingChanged)
    scoreTextField.textField.addTarget(self, action: #selector(observeScoreTextFieldState), for: .allEvents)
    subjectCheckMark.image = Assets.Images.checkMark.image
    
    viewModel.clearSubjectDataClosure = { [weak self] in
      self?.scoreTextField.text = ""
      viewModel.isSubjectSelected = false
      self?.subjectCheckMark.alpha = viewModel.isSubjectSelected ? 1 : 0
    }
    
    subjectLabel.text = viewModel.subjectName
    scoreTextField.text = viewModel.subjectScore
    
    viewModel.delegate?.updateResetButtonState(data: viewModel)
  }
  
  @objc private func changeScoreTextInTextField(_ textField: UITextField) {
    delegate?.changeScoreTextInTextField(with: textField)
  }
  
  @objc private func observeScoreTextFieldState(_ textField: UITextField) {
    if textField.isEditing {
      textField.layer.borderColor = UIColor.systemBlue.cgColor
      textField.layer.cornerRadius = 8
      textField.layer.borderWidth = 1
    } else {
      textField.layer.borderWidth = 0
    }
  }
  
  @objc private func changeMarkViewWithTextField(_ textField: UITextField) {
    subjectCheckMark.alpha = delegate?.changeCheckMarkViewWithTextField(with: textField) ?? false ? 1 : 0
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupSubjectWithScoreStackView()
    setupSubjectStackView()
    setupSubjectLabel()
    setupCheckMarkImage()
    setupSpacerView()
    setupScoreTextField()
  }
  
  private func setupSubjectWithScoreStackView() {
    addSubview(subjectWithScoreStackView)
    subjectWithScoreStackView.axis = .horizontal
    subjectWithScoreStackView.spacing = 16
    
    subjectWithScoreStackView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
      make.height.equalToSuperview().inset(15)
    }
  }
  
  private func setupSubjectStackView() {
    subjectWithScoreStackView.addArrangedSubview(subjectStackView)
    subjectStackView.axis = .horizontal
    subjectStackView.spacing = 4
    subjectStackView.alignment = .center
    
    subjectStackView.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.75)
    }
  }
  
  private func setupSubjectLabel() {
    subjectLabel.textColor = .Light.Text.primary
    subjectStackView.addArrangedSubview(subjectLabel)

    subjectLabel.snp.makeConstraints { make in
      make.width.lessThanOrEqualToSuperview()
    }
  }
  
  private func setupCheckMarkImage() {
    subjectCheckMark.tintColor = .Light.Text.primary
    subjectCheckMark.contentMode = .scaleAspectFit
    subjectCheckMark.clipsToBounds = true
    subjectStackView.addArrangedSubview(subjectCheckMark)
        
    subjectCheckMark.snp.makeConstraints { make in
      make.width.height.lessThanOrEqualTo(16)
    }
  }
  
  private func setupSpacerView() {
    let spacerView = UIView()
    subjectStackView.addArrangedSubview(spacerView)

    spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
  }
  
  private func setupScoreTextField() {
    scoreTextField.backgroundColor = .Light.Background.textInput
    scoreTextField.layer.cornerRadius = 8
    scoreTextField.textField.textAlignment = .center
    scoreTextField.textField.keyboardType = .numberPad
    scoreTextField.textField.addDoneButtonOnKeyboard()
    subjectWithScoreStackView.addArrangedSubview(scoreTextField)
    
    scoreTextField.snp.makeConstraints { make in
      make.verticalEdges.trailing.equalToSuperview()
    }
  }
}

// MARK: - PaddingDescribing

extension DisciplineTableCellView: PaddingsDescribing {
  var paddings: UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  }
}
