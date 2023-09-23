//
//  PhotoCarouselViewLayout.swift
//  TSUAbiturient
//

import UIKit

final class PhotoCarouselViewLayout: UICollectionViewFlowLayout {
      override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                        withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else { return proposedContentOffset }
        
        let pageLength = self.itemSize.width + self.minimumLineSpacing
        let approxPage = collectionView.contentOffset.x / pageLength
        var currentPage: CGFloat
        
        if velocity.x < 0 {
            currentPage = ceil(approxPage)
        } else if velocity.x > 0 {
            currentPage = floor(approxPage)
        } else {
            currentPage = round(approxPage)
        }
        
        guard velocity.x != 0 else { return CGPoint(x: currentPage * pageLength, y: 0) }
        
        let nextPage: CGFloat = currentPage + (velocity.x > 0 ? 1 : -1)
        
        return CGPoint(x: nextPage * pageLength, y: 0)
      }
}
