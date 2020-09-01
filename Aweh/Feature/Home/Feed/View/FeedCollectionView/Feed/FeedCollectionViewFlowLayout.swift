//
//  CollectionViewFlowLayout.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/03.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class FeedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private let itemSpacing: CGFloat = Const.View.m1
    private let margin: CGFloat = Const.View.m16
    private var imageHeight: CGFloat = 200
    private var estimatedHeight: CGFloat = 120
    
    private var cachedAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let cvBounds = collectionView.bounds.inset(by: collectionView.layoutMargins)
        let cvWidth = cvBounds.width
        
        self.itemSize = CGSize(width: cvWidth, height: estimatedHeight)
        self.sectionInset = UIEdgeInsets(top: minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        sectionInsetReference = .fromSafeArea
    }
  
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        return cachedAttributes
//            .map { $0.value }
//            .filter { $0.frame.intersects(rect) }
//    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let attributes = cachedAttributes[indexPath] else { fatalError("No attributes cached") }
//        return attributes
//    }
//
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
//        let midY: CGFloat = collectionView.bounds.size.height / 2
//        guard let closestAttribute = findClosestAttributes(toXPosition: proposedContentOffset.y + midY) else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
//        return CGPoint(x: closestAttribute.center.x, y: proposedContentOffset.y - midY)
//    }
//
//    private func findClosestAttributes(toXPosition xPosition: CGFloat) -> UICollectionViewLayoutAttributes? {
//        guard let collectionView = collectionView else { return nil }
//        let searchRect = CGRect(
//            x: collectionView.bounds.width, y: xPosition - collectionView.bounds.minY,
//            width: collectionView.bounds.width * 2, height: collectionView.bounds.height
//        )
//        return layoutAttributesForElements(in: searchRect)?.min(by: { abs($0.center.x - xPosition) < abs($1.center.x - xPosition) })
//    }
//
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        if collectionView?.bounds != newBounds {
//            cachedAttributes.removeAll()
//            return true
//        }
//        return false
//    }
//
//    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
//        if context.invalidateDataSourceCounts {
//            cachedAttributes.removeAll()
//        }
//        super.invalidateLayout(with: context)
//    }
//
//    private func createAttributesForItem(at indexPath: IndexPath, cellWidth: CGFloat) -> UICollectionViewLayoutAttributes? {
//        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//        attributes.frame.size = estimatedItemSize
//        attributes.frame.origin.y = CGFloat(indexPath.item) * (estimatedItemSize.height + itemSpacing)
//        attributes.frame.origin.x = (cellWidth - estimatedItemSize.width) / 2
//        return attributes
//    }
    
    // preferredLayoutAttributesFitting and estimatedSize
}
