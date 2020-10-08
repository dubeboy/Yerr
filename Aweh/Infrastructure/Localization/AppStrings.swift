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
        static func clampedValueNotInRage<T: Comparable>(value: T, range: ClosedRange<T>) -> String {
            String(format: "Clamped value %s is not in range: %s", "\(value)", "\(range)")
        }
        
        // For error analytics create a tuple that create represented as a string and has an ID as well??? 
        enum Analytics {
            static let photosReturnedNullImage = "Photos returned null error"
            static let nullStatusID = "Null status Id"
        }
    }
    
    enum FeedDetail {
        static let replyButton = "Reply"
        static let replyTextViewPlaceholderText = "Reply"
        static let replyPlaceholderText = "Reply to this status"
    }
    
    enum Feed {
        // TODO: use these for the accsiblities
        static let title = "Feed"
        static let likeButton = "Like"
        static let upvoteButton = "Up Vote"
        static let downVote = "Up Vote"
    }
    
    enum PostStatus {
        static let title = "Post Status"
        static let postStatusButtonTitle = "Post"
    }
    
    enum Shared {
        enum GeoLocationServices {
            static let failedToGetLocation = "Sorry failed to get your current location"
        }
    }
}
