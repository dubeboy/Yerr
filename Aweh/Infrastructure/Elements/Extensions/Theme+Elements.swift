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

//extension CGFloat {
//    static let const = Const()
//}
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
    enum Assets {
        enum Interests {
            static let iconCheckmark: UIImage? = UIImage(systemName: "checkmark.circle")
        }
        
        enum Defaults {
            static let defaultImageName = UIImage(named: "1") // this is the image that shows up while fetching from internet
        }
    }
    
    // MARK: Colors
    
    enum Color {
        static let lightGray = UIColor.systemGray6
        static let backgroundColor = UIColor.systemGray5
    }
}
