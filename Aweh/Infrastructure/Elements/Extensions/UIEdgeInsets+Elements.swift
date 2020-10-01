//
//  UIEdgeInsets+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/29.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    static func equalEdgeInsets(_ inset: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
