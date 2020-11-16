//
//  UICollectionFlowLayout+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func calculateItemSize(numberOfColumns: CGFloat) -> CGSize {
        let size = UIScreen.main.bounds
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightInset = flowLayout.sectionInset.right + flowLayout.sectionInset.left
        let interItemSpacing = flowLayout.minimumInteritemSpacing
        let cellSize = (size.width - leftRightInset - (interItemSpacing * 2)) / numberOfColumns
        return CGSize(width: cellSize, height: cellSize)
    }
}
