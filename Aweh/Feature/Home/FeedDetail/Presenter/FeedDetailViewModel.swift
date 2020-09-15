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

extension Comment {
    static func transform(comment: DetailCommentViewModel) -> Comment {
        Comment(body: comment.comment,
                user: User.transform(user: comment.user),
                media: [],
                createdAt: Date.init(timeIntervalSince1970: 23),
                location: Location(lat: 0, long: 0),
                id: nil)
    }
}

extension FeedDetailViewModel {
    static func tranform(feed: StatusViewModel) -> FeedDetailViewModel {
        FeedDetailViewModel(comments: [], feed: feed)
    }
}
