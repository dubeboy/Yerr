//
//  LayoutManager.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/13.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

class LayoutManager: NSLayoutManager {
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange: glyphsToShow, at: origin)
        guard let textStorage = textStorage,
              let currentCGContext = UIGraphicsGetCurrentContext() else {
            return
        }

        let characterRange = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        textStorage.enumerateAttribute(.backgroundColor, in: characterRange) { attr, bgStyleRange, _ in
            var rects = [CGRect]()
                let bgStyleGlyphRange = self.glyphRange(forCharacterRange: bgStyleRange, actualCharacterRange: nil)
                enumerateLineFragments(forGlyphRange: bgStyleGlyphRange) { _, usedRect, textContainer, lineRange, _ in
                    let rangeIntersection = NSIntersectionRange(bgStyleGlyphRange, lineRange)
//                    var rect = self.boundingRect(forGlyphRange: rangeIntersection, in: textContainer)
                    var rect = usedRect
                    // Glyphs can take space outside of the line fragment, and we cannot draw outside of it.
                    // So it is best to restrict the height just to the line fragment.
                    rect.origin.y = usedRect.origin.y
                    rect.size.height = usedRect.height
//                    let insetTop = self.layoutManagerDelegate?.textContainerInset.top ?? 0
                    rects.append(rect.offsetBy(dx: 0, dy: 10))
                }
                drawBackground(rects: rects, currentCGContext: currentCGContext)
        }
    }
    
    private func drawBackground(rects: [CGRect], currentCGContext: CGContext) {
        currentCGContext.saveGState()
        
        let rectCount = rects.count
        let rectArray = rects
        let cornerRadius: CGFloat = 10
        let color = UIColor.red
        
        for i in 0..<rectCount {
            var previousRect = CGRect.zero
            var nextRect = CGRect.zero
            
            let currentRect = rectArray[i]
            
            if i > 0 {
                previousRect = rectArray[i - 1]
            }
            
            if i < rectCount - 1 {
                nextRect = rectArray[i + 1]
            }
            
            let corners = calculateCornersForBackground(previousRect: previousRect, currentRect: currentRect, nextRect: nextRect, cornerRadius: CGFloat(cornerRadius))
            
            let rectanglePath = UIBezierPath(roundedRect: currentRect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            color.set()
            
            currentCGContext.setAllowsAntialiasing(true)
            currentCGContext.setShouldAntialias(true)
            
//            if let shadowStyle = backgroundStyle.shadow {
//                currentCGContext.setShadow(offset: shadowStyle.offset, blur: shadowStyle.blur, color: shadowStyle.color.cgColor)
//            }
//
            currentCGContext.setFillColor(color.cgColor)
            currentCGContext.addPath(rectanglePath.cgPath)
            currentCGContext.drawPath(using: .fill)
            
            let lineWidth: CGFloat = 0
            let overlappingLine = UIBezierPath()
            
            // TODO: Revisit shadow drawing logic to simplify a bit
            
            let leftVerticalJoiningLine = UIBezierPath()
            let rightVerticalJoiningLine = UIBezierPath()
            // Shadow for vertical lines need to be drawn separately to get the perfect alignment with shadow on rectangles.
            let leftVerticalJoiningLineShadow = UIBezierPath()
            let rightVerticalJoiningLineShadow = UIBezierPath()
            
            if previousRect != .zero, (currentRect.maxX - previousRect.minX) > 10 {
                let yDiff = currentRect.minY - previousRect.maxY
                overlappingLine.move(to: CGPoint(x: max(previousRect.minX, currentRect.minX) + lineWidth/2, y: previousRect.maxY + yDiff/2))
                overlappingLine.addLine(to: CGPoint(x: min(previousRect.maxX, currentRect.maxX) - lineWidth/2, y: previousRect.maxY + yDiff/2))
                
                let leftX = max(previousRect.minX, currentRect.minX)
                let rightX = min(previousRect.maxX, currentRect.maxX)
                
                leftVerticalJoiningLine.move(to: CGPoint(x: leftX, y: previousRect.maxY))
                leftVerticalJoiningLine.addLine(to: CGPoint(x: leftX, y: currentRect.minY))
                
                rightVerticalJoiningLine.move(to: CGPoint(x: rightX, y: previousRect.maxY))
                rightVerticalJoiningLine.addLine(to: CGPoint(x: rightX, y: currentRect.minY))
                
                let leftShadowX = max(previousRect.minX, currentRect.minX) + lineWidth
                let rightShadowX = min(previousRect.maxX, currentRect.maxX) - lineWidth
                
                leftVerticalJoiningLineShadow.move(to: CGPoint(x: leftShadowX, y: previousRect.maxY))
                leftVerticalJoiningLineShadow.addLine(to: CGPoint(x: leftShadowX, y: currentRect.minY))
                
                rightVerticalJoiningLineShadow.move(to: CGPoint(x: rightShadowX, y: previousRect.maxY))
                rightVerticalJoiningLineShadow.addLine(to: CGPoint(x: rightShadowX, y: currentRect.minY))
            }
            
//            if let borderColor =  {
//                currentCGContext.setLineWidth(lineWidth * 2)
//                currentCGContext.setStrokeColor(borderColor.cgColor)
//
//                // always draw vertical joining lines
//                currentCGContext.addPath(leftVerticalJoiningLineShadow.cgPath)
//                currentCGContext.addPath(rightVerticalJoiningLineShadow.cgPath)
//
//                currentCGContext.drawPath(using: .stroke)
//            }
            
            currentCGContext.setShadow(offset: .zero, blur:0, color: UIColor.clear.cgColor)
            
//            if let borderColor = backgroundStyle.border?.color {
//                currentCGContext.setLineWidth(lineWidth)
//                currentCGContext.setStrokeColor(borderColor.cgColor)
//                currentCGContext.addPath(rectanglePath.cgPath)
//
//                // always draw vertical joining lines
//                currentCGContext.addPath(leftVerticalJoiningLine.cgPath)
//                currentCGContext.addPath(rightVerticalJoiningLine.cgPath)
//
//                currentCGContext.drawPath(using: .stroke)
//            }
            
            // always draw over the overlapping bounds of previous and next rect to hide shadow/borders
            currentCGContext.setStrokeColor(color.cgColor)
            currentCGContext.addPath(overlappingLine.cgPath)
            // account for the spread of shadow
            let blur = 2
            let offsetHeight = abs(CGFloat(1))
//            currentCGContext.setLineWidth(lineWidth + (currentRect.minY - previousRect.maxY) + blur + offsetHeight + 1)
            currentCGContext.drawPath(using: .stroke)
        }
        currentCGContext.restoreGState()
    }
    
    private func calculateCornersForBackground(previousRect: CGRect, currentRect: CGRect, nextRect: CGRect, cornerRadius: CGFloat) -> UIRectCorner {
        var corners = UIRectCorner()
        
        if previousRect.minX > currentRect.minX {
            corners.formUnion(.topLeft)
        }
        
        if previousRect.maxX < currentRect.maxX {
            corners.formUnion(.topRight)
        }
        
        if currentRect.maxX > nextRect.maxX {
            corners.formUnion(.bottomRight)
        }
        
        if currentRect.minX < nextRect.minX {
            corners.formUnion(.bottomLeft)
        }
        
        if nextRect == .zero || nextRect.maxX <= currentRect.minX + cornerRadius {
            corners.formUnion(.bottomLeft)
            corners.formUnion(.bottomRight)
        }
        
        if previousRect == .zero || (currentRect.maxX <= previousRect.minX + cornerRadius) {
            corners.formUnion(.topLeft)
            corners.formUnion(.topRight)
        }
        
        return corners
    }
    
//    private func getCornersForBackground(textStorage: NSTextStorage, for charRange: NSRange) -> UIRectCorner {
//        let isFirst = (charRange.location == 0)
//            || (textStorage.attribute(.backgroundColor, at: charRange.location - 1, effectiveRange: nil) == nil)
//        
//        let isLast = (charRange.endLocation == textStorage.length) ||
//            (textStorage.attribute(.backgroundColor, at: charRange.location + charRange.length, effectiveRange: nil) == nil)
//        
//        var corners = UIRectCorner()
//        if isFirst {
//            corners.formUnion(.topLeft)
//            corners.formUnion(.bottomLeft)
//        }
//        
//        if isLast {
//            corners.formUnion(.topRight)
//            corners.formUnion(.bottomRight)
//        }
//        
//        return corners
//    }
}
