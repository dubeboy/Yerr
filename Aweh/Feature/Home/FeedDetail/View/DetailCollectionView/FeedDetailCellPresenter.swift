//
//  FeedDetailCellPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/19.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

class FeedDetailCellPresenter {
    func configure(with cell: FeedDetailCollectionViewCell, forDisplaying model: FeedDetailViewModel) {
        cell.userNameLabel.text = model.feed.user.name
        cell.userImage.downloadImage(fromUrl: model.feed.user.profilePicture)
//        cell.statusText.text = model.feed.status
    }
}
