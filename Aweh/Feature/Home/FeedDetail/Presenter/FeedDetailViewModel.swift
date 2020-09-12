//
//  FeedDetailViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/19.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

struct FeedDetailViewModel {
    var comments: [DetailCommentViewModel] = []
    let feed: StatusViewModel
}

// TODO: look into keypath so that we can acccess nested fields
struct DetailCommentViewModel {
    let user: UserViewModel
    let comment: String
    let timestamp: String
}

extension DetailCommentViewModel {
    static func tranform(comment: Comment) -> DetailCommentViewModel {
        DetailCommentViewModel(
            user: .transform(user: comment.user),
            comment: comment.body,
            timestamp: comment.createdAt.relativeDate()
        )
    }
}

extension FeedDetailViewModel {
    static func tranform(feed: StatusViewModel) -> FeedDetailViewModel {
        FeedDetailViewModel(comments: [], feed: feed)
    }
}
