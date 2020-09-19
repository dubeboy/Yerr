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
    
    var lineColor: CGColor = UIColor.yellow.cgColor
    var lineWidth: CGFloat = 10.0
    var startRadAngle: CGFloat = -.toRad(angle: 0)
    var endRadAngle: CGFloat = 0.0 {
        didSet {
            basicAnimation(angle: endRadAngle)
        }
    }
    
//    override init() {
//        super.init()
//        basicAnimation(angle: T##CGFloat)
//    }
    
    override func draw(in ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2 , y: bounds.height / 2)
        ctx.beginPath()
        
        ctx.setStrokeColor(lineColor)
        ctx.setLineWidth(lineWidth)
        ctx.addArc(
            center: center,
            radius: (bounds.height / 2) - lineWidth,
            startAngle: startRadAngle,
            endAngle: endRadAngle,
            clockwise: false
        )
        ctx.setFillColor(UIColor.clear.cgColor)
        ctx.setLineCap(.round)
        ctx.drawPath(using: .stroke)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "endAngle" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    private func basicAnimation(angle toValue: CGFloat) {
        let basicAnimation = CABasicAnimation(keyPath: "endAngle")
        basicAnimation.toValue = toValue
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        add(basicAnimation, forKey: "myBasicAnimation")
    }
}
