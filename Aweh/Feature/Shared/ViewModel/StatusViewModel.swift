//
//  HomeScreenViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/03.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

struct StatusViewModel: Equatable, Hashable {
    // TODO: some sort  of id here to help me get the status withis id from server
    let status: String
    let userName: String
    let media: Media? // todo: should be an array!
    let userImage: String?
    let timeSincePosted: String
    let distanceFromYou: String // TODO empty for now
}

extension StatusViewModel {
    static func transform(from post: Post) -> Self {
        
        StatusViewModel(
            status: post.body, // no need for it attr string
            userName: post.authorName,
            media: post.media,
            userImage: post.authorProfilePicUUID,
            timeSincePosted: Date.fromString(string: post.timestamp).relativeDate(),
            distanceFromYou: ""
        )
    }
    
    
}
