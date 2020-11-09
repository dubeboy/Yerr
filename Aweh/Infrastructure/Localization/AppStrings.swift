//
//  AppStrings.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/21.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

// Should localize these strings in the future
// Afrikaans
// Zulu


enum AppStrings {
    enum Error {
        static let genericError = "Sorry something unexpected happened. Please try again."
        static let noInternetConnection = "Sorry something unexpected happened. Please make sure you are connected to the internet."
        static let interestNameNil = "Inetrest name is nil"
        static func clampedValueNotInRage<T: Comparable>(value: T, range: ClosedRange<T>) -> String {
            String(format: "Clamped value %s is not in range: %s", "\(value)", "\(range)")
            
        }
        
        static let InvalideColor = "Invalide hex color, therefore cannot be convert to UIInt32"
        
        // For error analytics create a tuple that create represented as a string and has an ID as well??? 
        enum Analytics {
            static let photosReturnedNullImage = "Photos returned null error"
            static let nullStatusID = "Null status Id"
        }
        
        enum Profile {
            static let IncositentViewModel: String = "View Model is in an inconstent state"
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
    
    enum Interests {
        static let title: String = "Interests"
    }
    
    enum Profile {
        static let pleaseSignIn: String = "Please Sign in"
    }
    
    enum AcceptTsAndCs {
        static let title: String = "Welcome to Yerr"
        static let acceptTsAndCsButtonTitle: String = "Agree & Continue"
        static let acceptTsAndC: String = #"Tap "\#(acceptTsAndCsButtonTitle)" to accept the Yerr "#
        static let linkToTsCs: String = "Terms of Service and Privacy Policy"
    }

    enum InitPhoneNumberInput {
        static let confirmPhoneNumberText = "Please confirm you country code and enter your phone number"
        static let phoneNumberPlaceholderText = "Your phone number"
        static let title = "Your phone number"
        static let doneBarButton = "Done"
    }
    
    enum InfoInput {
        static let namePlaceHolder = "Your Name"
        static let handlePlaceHolder = "Your Handle"
        static let title = "Complete Your Profile"
        static let doneButtonTitle = "Done"
    }
    
    // InitPhoneNumberVerification
    enum OTP {
        static let headerText = "We have sent you an SMS with a code to the number above. \n\nTo Complete your phone number verification, please enter the 6-digit activation code."
        static let resend = "Resend"
        
        static let continueTitle = "Continue"
    }
    
    enum InitCoutryLists {
        static let title = "Select Your Country"
    }
    
    enum Shared {
        enum GeoLocationServices {
            static let failedToGetLocation = "Sorry failed to get your current location"
        }
        
        enum UserDefaults: String {
            case userId
            case userName
            case currentViewController
            case didFinishLaunching
        }
    }
}
