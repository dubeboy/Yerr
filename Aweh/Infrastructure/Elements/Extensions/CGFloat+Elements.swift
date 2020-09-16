//
//  CGFloat+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/16.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    static func toRad(angle degrees: CGFloat) -> CGFloat {
        degrees * (CGFloat.pi / 180)
    }
    
}
