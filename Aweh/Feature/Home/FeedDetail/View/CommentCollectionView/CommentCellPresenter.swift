//
//  CommentCellPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/19.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

class CommentCellPresenter {
    func configure(with cell: CommentCollectionViewCell, forDisplaying viewModel: DetailCommentViewModel) {
        cell.userName.text = viewModel.user.name
        cell.comment.text = viewModel.comment
        cell.userProfileImage.downloadImage(fromUrl: viewModel.user.profilePicture)
        cell.timestamp.text = viewModel.timestamp
    }
}
