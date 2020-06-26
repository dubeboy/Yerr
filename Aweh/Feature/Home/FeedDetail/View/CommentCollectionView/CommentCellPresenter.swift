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
        cell.userName.text = viewModel.userName
        cell.commentText.text = viewModel.comment
        cell.userProfileImage.image = viewModel.userImage
        cell.timestamp.text = viewModel.timestamp
    }
}
