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
    
    // MARK: App assets
    enum Assets {
        enum Interests {
            static let iconCheckmark: UIImage? = getSystemResource(systemName: "checkmark.circle")
        }
        
        enum Defaults {
            // this is the image that shows up while fetching from internet
            static let defaultImageName = UIImage(named: "1")
        }
        
        enum FeedDetail {
            static let iconImage: UIImage? = getSystemResource(systemName: "photo")
            static let replayImage: UIImage? =  getSystemResource(systemName: "paperplane")
        }
        
        enum Feed {
            static let upVoteArrow: UIImage? = getSystemResource(systemName: "arrow.up")
            static let downVoteArrow: UIImage? = getSystemResource(systemName: "arrow.down")
            static let likeFill: UIImage? = getSystemResource(systemName: "heart.fill")
            static let like: UIImage? = getSystemResource(systemName: "heart")
        }
        
        enum InitPhoneNumber {
            static let chevronRight: UIImage? = getSystemResource(systemName: "chevron.right")
        }
        
        enum InitInfoInput {
            static let editButton: UIImage? = getSystemResource(systemName: "pencil")
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
    // MARK: Colors
    /// Note: these color must support dark mode
    /// default naming: light mode
    enum Color {
        
        // SHould have a private BASE
        // then put all the System colors in system
        // These should be private!!
        static let lightGray = UIColor.systemGray6
        static let backgroundColor = UIColor.systemGray5
        static let systemWhite = UIColor.systemBackground
        static let actionButtonColor = UIColor(named: "blueActionButton")! // TODO: test that these color exist
        static let label = UIColor.label
        static let linkColor = UIColor.link
        
        enum Feed {
            static let commentBox = lightGray
            static let trackColor = Color.actionButtonColor
            static let trackBackGroundColor = Color.lightGray
            static let textColor = Color.label
            static let warningMaximumTextLength = UIColor.systemYellow
            static let alertMaximumTextLength = UIColor.systemRed
        }
        
        enum InitInfoInput {
            static let resendColor = linkColor
            static let continueColor = linkColor
        }
    }
    
    private static func getSystemResource(systemName: String) -> UIImage? {
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
    
    private static func getColor(color: Color) -> UIColor {
        
    }
}
