//
//  TableCellContainer.swift
//  TSUAbiturient
//

import UIKit

class TableCellContainer<ItemView: UIView>: UITableViewCell, TableCell where ItemView: Configurable {
  private let itemView = ItemView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  func configure(with viewModel: TableCellViewModel) {
    if let viewModel = viewModel as? ItemView.ViewModel {
      itemView.configure(with: viewModel)
    }
  }
  
  private func setup() {
    contentView.addSubview(itemView)
    backgroundColor = .clear
    
    let paddings = (itemView as? PaddingsDescribing)?.paddings ?? .zero
    
    itemView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(paddings)
    }
    
    selectionStyle = .none
  }
}
