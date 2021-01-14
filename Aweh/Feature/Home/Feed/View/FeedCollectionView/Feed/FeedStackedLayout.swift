//
//  FeedStackedLayout.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

// https://github.com/gleue/TGLStackedViewController/blob/master/TGLStackedViewController/TGLStackedLayout.m
// version two will have the nice layout!!!
class FeedStackedLayout: UICollectionViewLayout {
    
    private var layoutMargin: UIEdgeInsets = .equalEdgeInsets(Const.View.m16)
    private var bounceFactor: Double = 0.2
    private var movingItemScaleFactor = 0.95
    private var isMovingItemsOnTop: Bool = true
    private var itemSize: CGSize = .zero
    
    override init() {
        super.init()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        layoutMargin = .equalEdgeInsets(Const.View.m16)
        bounceFactor = 0.2
        movingItemScaleFactor = 0.95
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
//    - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
//
//    // Honor overwritten contentOffset
//    //
//    // See http://stackoverflow.com/a/25416243
//    //
//    return self.overwriteContentOffset ? self.contentOffset : proposedContentOffset;
//    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        var contentSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height - (layoutMargin.top + layoutMargin.bottom))
        
        if contentSize.height < collectionView.bounds.height {
            contentSize.height = collectionView.bounds.height
        }
        return contentSize
    }
    
    
    override func prepare() {
//        collectionViewContentSize
        guard let collectionView = collectionView else { return }
        var layouSize = CGSize(width: collectionView.bounds.width - layoutMargin.left - layoutMargin.right ,
                               height: collectionView.bounds.height - layoutMargin.top - layoutMargin.bottom)
        
        
        var itemSize = self.itemSize
        
        if itemSize.width == 0 {
            itemSize.width = layouSize.width
        }
        
        if itemSize.height == 0 {
            itemSize.height = layouSize.height
        }
        
        var itemHorizontalOffset = 0.5 * (layouSize.width - itemSize.width)
        var itemOrigin = CGPoint(x: layoutMargin.left + floor(itemHorizontalOffset), y: 0.0)
        
        
        
    }
}
