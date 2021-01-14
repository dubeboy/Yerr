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
        dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeHeader<T: UICollectionViewCell>(_ `class`: T.Type, at indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.reuseIdentifier, for: indexPath
        ) as! T
    }
    
    func register<T: UICollectionViewCell>(_ fromNib: T.Type) {
        register(
            UINib(nibName: T.reuseIdentifier, bundle: Bundle.main),
            forCellWithReuseIdentifier: T.reuseIdentifier
        )
    }
    
    func registerClass<T: UICollectionViewCell>(_ `class`: T.Type) {
        register(
            `class`,
            forCellWithReuseIdentifier: T.reuseIdentifier
        )
    }
    
    func registerHeader<T: UICollectionViewCell>(_ fromNib: T.Type) {
        register(
            UINib(nibName: T.reuseIdentifier, bundle: Bundle.main),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.reuseIdentifier
        )
    }
    
    
}

// TODO: this should be in the NSObject class
extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    func configureContentView() {
        contentView.backgroundColor = Const.Color.backgroundColor
        contentView.clipsToBounds = true
    }
}


