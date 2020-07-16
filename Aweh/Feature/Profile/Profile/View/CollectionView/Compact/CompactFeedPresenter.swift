//
//  CompactFeedPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/15.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

class CompactFeedPresenter {
    func configure(with cell: CompactFeedCollectionViewCell, forDisplaying model: StatusViewModel) {
        if let image = model.statusImage {
            cell.imageView.image = image
            cell.statusText.attributedText = model.status
        } else {
            cell.compactBackGroundView.isHidden = true
            cell.imageView.isHidden = true
        }
    }
}
