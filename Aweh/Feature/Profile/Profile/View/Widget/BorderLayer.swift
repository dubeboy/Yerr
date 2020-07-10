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
    var startAngle: CGFloat = 0.0
    dynamic var endAngle: CGFloat = 0.0
    
    override func draw(in ctx: CGContext) {
        let center = CGPoint(x: bounds.width/2 , y: bounds.height/2)
        ctx.beginPath()
        ctx.setStrokeColor(lineColor)
        ctx.setLineWidth(lineWidth)
        ctx.addArc(
            center: center,
            radius: (bounds.height/2) - lineWidth,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        // add curve!
        ctx.drawPath(using: .stroke)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "endAngle" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    
}
