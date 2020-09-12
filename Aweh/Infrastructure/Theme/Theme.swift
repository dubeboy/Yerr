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
    // MARK: View Constants
    enum View {
        static let m24: CGFloat = 24
        static let m16: CGFloat = 16
        static let m8: CGFloat = 8
        static let m1: CGFloat = 1
        static let m2: CGFloat = 2
        static let m4: CGFloat = 2
        static let radius: CGFloat = 10
        static let borderWidth: CGFloat = m2
    }
    
    // MARK: App assets
    /// gets SFSymbols if iOS 13+ else gets local resource
    enum Assets {
        enum Interests {
            static let iconCheckmark: UIImage? = getSystemResource(systemName: "checkmark.circle")
        }
        
        enum Defaults {
            // this is the image that shows up while fetching from internet
            static let defaultImageName = UIImage(named: "1")
        }
        
        enum Common {
            static let iconImage: UIImage? = getSystemResource(systemName: "photo")
        }
        
    }
//    https://colorhunt.co/palette/201882 dark theme baby
//    https://colorhunt.co/palette/196113
    // MARK: Colors
    /// Note: these color must support dark mode
    /// default naming: light mode
    enum Color {
        static let lightGray = UIColor.systemGray6
        static let backgroundColor = UIColor.systemGray5
        static let systemWhite = UIColor.systemBackground
        static let actionButtonColor = UIColor(named: "blueActionButton")
    }
    
    private static func getSystemResource(systemName: String) -> UIImage? {
        if #available(iOS 13, *) {
            return UIImage(systemName: systemName)
        } else {
            return UIImage(named: systemName)
        }
    }
}
