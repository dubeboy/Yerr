//
//  BorderLayer.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/07.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

class BorderLayer: CALayer {
    
    static let startAngle = 3 / 2 * CGFloat.pi
    static let endAngle = 7 / 2 * CGFloat.pi
    
    var lineColor: CGColor = UIColor.yellow.cgColor
    var lineWidth: CGFloat = 2.0
    var startAngle: CGFloat = 0.0
    dynamic var endAngle: CGFloat = 0.0
    
    override func draw(in ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2 , y: bounds.height / 2)
        ctx.beginPath()
        ctx.setStrokeColor(lineColor)
        ctx.setLineWidth(lineWidth)
        ctx.addArc(
            center: center,
            radius: bounds.height / 2 - lineWidth,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        ctx.drawPath(using: .stroke)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "endAngle" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    static func radianForValue(_ value: CGFloat) -> CGFloat {
        let realValue = Self.sanitizeValue(value: value)
        return (realValue * 4/2 * CGFloat.pi / 100) + Self.startAngle
    }
    
    static func sanitizeValue(value: CGFloat) -> CGFloat {
        var realValue = value
        if value < 0 {
            realValue = 0
        } else if value > 100 {
            realValue = 100
        }
        return realValue
    }
    
    
}
