//
//  UINavigationController+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/12/16.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func makeTransparent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        backgroundColor = .clear
        
        if #available(iOS 13.0, *) {
            standardAppearance.backgroundColor = .clear
            standardAppearance.backgroundEffect = nil
            standardAppearance.shadowColor = .clear
        }
    }
    
    func removeTransparency() {
        isTranslucent = false
        barTintColor = nil
        shadowImage = nil
    }
}



