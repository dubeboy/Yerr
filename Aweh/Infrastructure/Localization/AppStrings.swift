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

    // MARK: Common
    
    private static let appName = "Yerr"
    private static let ok = "Ok"
    private static let cancel = "Cancel"
    
  
    enum Error {
        static let genericError = "Sorry something unexpected happened. Please try again."
        static let noInternetConnection = "Sorry something unexpected happened. Please make sure you are connected to the internet."
        static let interestNameNil = "Inetrest name is nil"
        static func clampedValueNotInRage<T: Comparable>(value: T, range: ClosedRange<T>) -> String {
            String(format: "Clamped value %s is not in range: %s", "\(value)", "\(range)")
        }
        
        static let invalideColor = "Invalide hex color, therefore cannot be convert to UIInt32"
        
        // For error analytics create a tuple that create represented as a string and has an ID as well??? 
        enum Analytics {
            static let photosReturnedNullImage = "Photos returned null error"
            static let nullStatusID = "Null status Id"
        }
        
        enum Profile {
            static let incositentViewModel: String = "View Model is in an inconstent state"
        }
        
        enum StatusVideoPlayer {
            static let invalidURL: String = "Invalid status video URL"
        }
        
        enum TrimVideo {
            static let createCompositionalTrackFailed = "Something went wrong with the asset"
            static let exportFailed = "Export failed"
            static let cannotConvertStringURLToURLObject = "Cannnot convert URL string to URL object"
        }
        
        enum CaptureStatus {
            static let phoneIsOverHeating = "Sorry cannot launch your camera right now because your phone is over heating."
            static let cameraPaused = "Camera session has been paused. reason %s"
            static let cameraResumed = "Camera session interuption has ended."
            static let configrationFailed = "Something went wrong camera configuration."
            static let notAuthOrDet = "Access to photos is not Determined or denied"
            static let unknown = "Access to photos has an unkown state"
        }
        
    }
    
    enum FeedDetail {
        static let title = "Comments"
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
    
    enum CaptureStatus {
        // all of these should be moved to error
        static let cameraAccessRequired = "Please enable camera access."
        static let frontCameraNotAvailable = "Front camera not available."
        static let backCameraNotAvailable = "Back camera not available."
        static let noInputDeviceForBackCamera = "Could not create input device from back camera."
        static let noInputDeviceForFrontCamera = "Could not create input device from front camera."
        static let unableToAddBackCameraToSession = "could not add back camera input to capture session."
        static let unableToAddFrontCameraToSession = "Could not add front camera input to capture session."
        static let unableToAddVideoOutputToSession = "Could not add video output to session."
        
        static let phoneIsOverHeating = "Sorry cannot lauch your camera right now because your phone is over heating. Please try again later."
        static let videoRecPausedAudioInUse = "Video recording has been paused.\n\nAudio in use."
        static let cameraPausedTapToResume = "Camera session has been paused.\n\nTap to resume."
        static let configrationFailed = "Something went wrong camera configuration. Please try again."
        
        static let permissionToCameraNotGranted = "\(appName) doesn't have permission to use the camera, please change privacy settings."
        static let alertTitle = appName
        static let alertOk = ok
        static let settings = "Settings"

    }
    
    enum TrimVideo {
        static let createCompositionalTrackFailed = "Failed to edit asset. Please try another one."
        static let exportFailed = "Sorry export failed. Please try again."
        static let assetNotFound = "Sorry cannot find your media asset. Please try again."
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
            static let failedToGetLocation = "Sorry failed to get your current location."
        }
        
        enum UserDefaults: String {
            case userId
            case userName
            case currentViewController
            case didFinishLaunching
        }
        
        enum Extensions {
            enum UIAlertViewController {
                static let alertTitle = appName
                static let alertOk = ok
                static let alertCancel = cancel
                
            }
        }

    }
}
