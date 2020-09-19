//
//  CGFloat+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/16.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    private static func toRad(angle degrees: CGFloat) -> CGFloat {
        degrees * (CGFloat.pi / 180)
    }
    
    static func toRadNormalized(angle degrees: CGFloat) -> CGFloat {
        (degrees - 90) * (CGFloat.pi / 180)
    }
}
