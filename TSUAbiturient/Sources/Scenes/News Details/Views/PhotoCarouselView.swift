//
//  PhotoCarouselView.swift
//  TSUAbiturient
//

import UIKit

final class PhotoCarouselView: UIView {
  // MARK: - Properties
  
  var itemSize: CGSize {
    get {
      layout.itemSize
    }
    set {
      layout.itemSize = newValue
    }
  }
  
  private var layout = PhotoCarouselViewLayout()
  private var collectionView: UICollectionView?
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, URL?>?
  
  private let horizontalInsets: CGFloat
  
  private enum Section {
    case main
  }
  
  // MARK: - Inits
  
  init(horizontalInsets: CGFloat = 24) {
    self.horizontalInsets = horizontalInsets
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("PhotoCarouselView init(coder: NSCoder) has not been implemented")
  }
  
  // MARK: - Configure
  
  func configure(withURLs urls: [URL?]) {
    
    let currentShapshot = dataSource?.snapshot()
    
    guard var currentShapshot = currentShapshot else { return }
    
    currentShapshot.deleteAllItems()
    currentShapshot.appendSections([Section.main])
    currentShapshot.appendItems(urls, toSection: Section.main)
    
    dataSource?.apply(currentShapshot, animatingDifferences: false)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupLayout()
    setupCollectionView()
    setupDataSource()
  }
  
  private func setupLayout() {
    layout = PhotoCarouselViewLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInsets, bottom: 0, right: horizontalInsets)
    layout.minimumLineSpacing = 8
    layout.scrollDirection = .horizontal
    layout.itemSize = self.itemSize
  }
  
  private func setupCollectionView() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    guard let collectionView = collectionView else { return }
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.decelerationRate = .fast
    collectionView.register(PhotoCarouselUnitView.self, forCellWithReuseIdentifier: PhotoCarouselUnitView.reuseIdentifier)
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupDataSource() {
    guard let collectionView = collectionView else { return }
    dataSource = UICollectionViewDiffableDataSource<Section, URL?>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCarouselUnitView.reuseIdentifier,
                                                          for: indexPath) as? PhotoCarouselUnitView else {
        return UICollectionViewCell()
      }
      cell.configure(with: itemIdentifier)
      return cell
    }
    collectionView.dataSource = dataSource
  }
}
