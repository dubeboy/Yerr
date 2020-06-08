//
//  UICollectionView+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/06.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    // could also add some registration that uses properwrappers

    
    func deque<T: UICollectionViewCell>(_ `class`: T.Type, at indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: `class`), for: indexPath) as! T
    }
    
//    var selectedCell: GroceryListItemCell {
//        let indexPath = self.indexPathsForSelectedItems!.first!
//        return self.cellForItem(at: indexPath) as! GroceryListItemCell
//    }
}
