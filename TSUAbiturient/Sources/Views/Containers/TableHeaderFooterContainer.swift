//
//  TableHeaderFooterContainer.swift
//  TSUAbiturient
//

import UIKit

class TableHeaderFooterContainer<ItemView: UIView>: UITableViewHeaderFooterView,
                                                    TableHeaderFooterView where ItemView: Configurable {
  // MARK: - Properties
  
  private let itemView = ItemView()
  
  // MARK: - Inits
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Configure
  
  func configure(with viewModel: TableHeaderFooterViewModel) {
    if let viewModel = viewModel as? ItemView.ViewModel {
      itemView.configure(with: viewModel)
    }
  }
  
  // MARK: - Setup
  
  private func setup() {
    contentView.addSubview(itemView)
    contentView.backgroundColor = .clear
    
    let paddings = (itemView as? PaddingsDescribing)?.paddings ?? .zero
    
    itemView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(paddings)
    }
  }
}
