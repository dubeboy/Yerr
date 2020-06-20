//
//  FeedDetailCellPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/19.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

class FeedDetailCellPresenter {
    func configure(with cell: FeedDetailCollectionViewCell, forDisplaying model: FeedDetailViewModel){
        let status = model.feed
        cell.userHandleLabel.isHidden = true
        cell.mediaCollectionView.isHidden = true
        cell.mediaCollectionView.backgroundColor = .systemBlue
        cell.userNameLabel.text = status.userName
        cell.userImage.image = status.userImage
        cell.statusText.text = status.status.string
    }
}
