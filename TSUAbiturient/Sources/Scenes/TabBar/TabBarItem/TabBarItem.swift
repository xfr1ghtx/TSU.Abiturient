//
//  TabBarItem.swift
//  TSUAbiturient
//

import UIKit

protocol TabBarItem: Hashable, Equatable {
  var title: String { get }
  var icon: UIImage { get}
}
