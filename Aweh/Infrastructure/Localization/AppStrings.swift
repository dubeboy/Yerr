//
//  AppStrings.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/21.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

// Should localize these strings in the future
enum AppStrings {
    enum Error {
        static let genericError = "Sorry something unexpected happened. Please try again."
        static let noInternetConnection = "Sorry something unexpected happened. Please make sure you are connected to the internet."
    }
    
    enum FeedDetail {
        static let replyButton = "Reply"
        static let replyTextViewPlaceholderText = "Reply"
        static let replyPlaceholderText = "Reply to this status"
    }
    
    enum Feed {
        // TODO: use these for the accsiblities
        static let likeButton = "Like"
        static let upvoteButton = "Up Vote"
        static let downVote = "Up Vote"
    }
    
    enum Shared {
        enum GeoLocationServices {
            static let failedToGetLocation = "Sorry failed to get your current location"
        }
    }
}
