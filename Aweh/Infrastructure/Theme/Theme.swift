//
//  Theme+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/07.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

// color + sizes + fonts etc all in here

// MARK: - App Constants

enum Const {
    static let maximumTextLength: Int = 280
    // MARK: View Constants
    enum View {
        static let m24: CGFloat = 24
        static let m16: CGFloat = 16
        static let m8: CGFloat = 8
        static let m12: CGFloat = 12
        static let m1: CGFloat = 1
        static let m2: CGFloat = 2
        static let m4: CGFloat = 2
        static let radius: CGFloat = 10
        static let borderWidth: CGFloat = m2
        
    }
    
    // MARK: - App assets
    enum Assets {
        
        // Global icons, usualy in extensions
        static let closeIcon: UIImage? = getSystemAsset(systemName: "xmark")
        static let cameraIcon = getSystemAsset(systemName: "camera")
        
        private enum CommonAssets {
            static let chevronRight: UIImage? = getSystemAsset(systemName: "chevron.right")
        }
         
        enum Interests {
            static let iconCheckmark: UIImage? = getSystemAsset(systemName: "checkmark.circle")
        }
        
        enum Defaults {
            // this is the image that shows up while fetching from internet
            static let defaultImageName = UIImage(named: "1")
        }
        
        enum FeedDetail {
            static let iconImage: UIImage? = getSystemAsset(systemName: "photo")
            static let replayImage: UIImage? =  getSystemAsset(systemName: "paperplane")
        }
        
        enum Feed {
            static let upVoteArrow: UIImage? = getSystemAsset(systemName: "hand.thumbsup.fill")
            static let downVoteArrow: UIImage? = getSystemAsset(systemName: "hand.thumbsdown.fill")
            static let likeFill: UIImage? = getSystemAsset(systemName: "heart.fill")
            static let like: UIImage? = getSystemAsset(systemName: "heart")
        }
        
        enum CaptureStatus {
            static let openGalleryIcon: UIImage? = UIImage(named: "gallery")
            static let chevronUp: UIImage? = getSystemAsset(systemName: "chevron.up")
        }
        
        enum TrimVideo {
            static let playVideoIcon: UIImage? = getSystemAsset(systemName: "play.circle.fill")
        }
        
        enum InitPhoneNumber {
            static let chevronRight: UIImage? = CommonAssets.chevronRight
        }
        
        enum InitInfoInput {
            static let editButton: UIImage? = getSystemAsset(systemName: "pencil")
        }
        
        enum InitCountryLists {
            static let chevronRight: UIImage? = CommonAssets.chevronRight
        }
        
        enum PostStatus {
            static let color: UIImage? = getSystemAsset(systemName: "circle.fill")
            static let textAlignmentCenter: UIImage? = getSystemAsset(systemName: "text.aligncenter")
            static let testAlignmentLeft: UIImage? = getSystemAsset(systemName: "text.alignleft")
            static let testAlignmentRight: UIImage? = getSystemAsset(systemName: "text.alignright")
            static let normalText: UIImage? = getSystemAsset(systemName: "bold")
            static let boldText: UIImage? = {
                let image: UIImage?
                if #available(iOS 13.0, *) {
                   image =  UIImage(systemName: "bold", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))
                } else {
                   image = UIImage(named: "icon.bold")
                }
                return image
            }()
            static let italicText: UIImage? = getSystemAsset(systemName: "italic")
            static let changeTextBackgroundSelected: UIImage? = getSystemAsset(systemName: "eyedropper.halffull")
            static let changeTextBackground: UIImage? = getSystemAsset(systemName: "eyedropper")
        }
        
        private static func getSystemAsset(systemName: String) -> UIImage? {
            if #available(iOS 13, *) {
                let image = UIImage(systemName: systemName)
                if image == nil {
                    Logger.log("\(#function) image is nil")
                }
                return image
            } else {
                let image = UIImage(named: systemName)
                if image == nil {
                    Logger.log("\(#function): image is nil")
                }
                return image
            }
        }
        
    }
    
//    enum Font {
//        enum FeedDetail {
////            static let circleProgressIndicator = UIFont(
//        }
//    }
//    
//    https://colorhunt.co/palette/201882 dark theme baby
//    https://colorhunt.co/palette/196113
    // MARK: - Colors
    /// Note: these color must support dark mode
    /// default naming: light mode
    
  
    
    enum Color {
        
        fileprivate enum AppThemeColors {
            case grayItem
            case background
            case widget
            
            case button
            
            case label
            
            case link
        }
        
       
       
        // SHould have a private BASE
        // then put all the System colors in system
        // These should be private!!
        static let lightGray = getColor(color: .grayItem)
        static let backgroundColor = getColor(color: .background)
        static let systemWhite = getColor(color: .widget)
        static let actionButtonColor = getColor(color: .button) // TODO: test that these color exist
        static let labelColor = getColor(color: .label)
        static let linkColor = getColor(color: .link)
        static let navigationBarTintColor = UIColor.white
        
        private static let colors = ["264653", "2A9D8F", "e9c46a", "f4a261", "e76f51"]
        
        
        enum PostStatus {
            static let textBackgroundColors = colors
        }
        
        enum Feed {
            static let commentBox = lightGray
            static let trackColor = Color.actionButtonColor
            static let trackBackGroundColor = lightGray
            static let textColor = linkColor
            static let warningMaximumTextLength = UIColor.systemYellow
            static let alertMaximumTextLength = UIColor.systemRed
        }
        
        enum InitInfoInput {
            static let resendColor = linkColor
            static let continueColor = linkColor
        }
        
        enum CaptureStatus {
            static let captureButton = UIColor.white
        }
        enum TrimVideo {
            static let playVideo = UIColor.white
            static let videoOverlayBackGround = UIColor.black.withAlphaComponent(0.2)
            static let textBackgroundColors = colors
        }
    }

    private static func getColor(color: Color.AppThemeColors) -> UIColor {
        switch color {
            case .grayItem:
                if  #available(iOS 13.0, *) {
                    return UIColor.systemGray6
                } else {
                    return UIColor.lightGray
                }
            case .background:
                if  #available(iOS 13.0, *) {
                    return UIColor.systemBackground
                } else {
                    return UIColor.white
                }
            case .widget:
                if  #available(iOS 13.0, *) {
                    return UIColor.systemBackground
                } else {
                    return UIColor.white
                }
            case .button:
                return UIColor(named: "blueActionButton")!
            case .label:
                if  #available(iOS 13.0, *) {
                    return UIColor.label
                } else {
                    return UIColor.lightText
                }
            case .link:
                if  #available(iOS 13.0, *) {
                    return UIColor.link
                } else {
                    return UIColor.blue
                }
        }
    }
}
