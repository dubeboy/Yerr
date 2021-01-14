//
//  OverlayTextView.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/05.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

class OverlayTextView: UITextView {
    let parent: UIView
    
    var blurEffectView: UIVisualEffectView!
    let newLayoutManager = LayoutManager()
    let storage = NSTextStorage()
    
    init(parent: UIView, backgroundColor: UIColor = .cyan, tag: Int = 0) {
        self.parent = parent
        storage.addLayoutManager(newLayoutManager)
        let container = NSTextContainer(size: .zero)
        container.widthTracksTextView = true
        newLayoutManager.addTextContainer(container)
        
        super.init(frame: .zero, textContainer: container)
//        self.backgroundColor = backgroundColor.withAlphaComponent(0.6)
        self.isScrollEnabled = false
        self.tag = tag
//        self.sizeToFit()
//
//        self.addShadow()
//        self.layer.cornerRadius = Const.View.radius
//        let blurEffect = UIBlurEffect(style: .prominent)
//        blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.frame
//        blurEffectView.clipsToBounds = true
////        blurEffectView.autoresizingOff()
//
//        self.addSubview(blurEffectView)
//        self.sendSubviewToBack(blurEffectView)
//
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didMoveOverlayTextView(recognizer:)))
        self.addGestureRecognizer(panGesture)
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateOverlayTextView(recognizer:)))
        self.addGestureRecognizer(rotationGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self , action: #selector(didPichOverlayTextView(recognizer:)))
        self.addGestureRecognizer(pinchGesture)
        
        self.layoutManager.delegate = self
        self.attributedText = NSAttributedString(string: "Text Sring with some lemon \n SOme new things",  attributes: [NSAttributedString.Key.backgroundColor: UIColor.green])
        self.textAlignment = .center

        
        panGesture.delegate = self
        rotationGesture.delegate = self
        pinchGesture.delegate = self
       
        
        // add dymanic font too so that when the view inccrease al the text increases
        // add a hit test to see what the user is trying to do and assign that action this view
        // animatye gestures when below the keyboad
        
        
        
    }
    
//    let textViewPadding: CGFloat = 7.0
//
//    override func draw(_ rect: CGRect) {
//        self.layoutManager.enumerateLineFragments(forGlyphRange: NSMakeRange(0, self.text.count)) { (rect, usedRect, textContainer, glyphRange, Bool) in
//
//            let rect = CGRect(x: usedRect.origin.x, y: usedRect.origin.y + self.textViewPadding, width: usedRect.size.width, height: usedRect.size.height*1.2)
//            let rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: 3)
//            UIColor.red.setFill()
//            rectanglePath.fill()
//            self.setNeedsDisplay()
//        }
//    }
//
    override func layoutSubviews() {
        super.layoutSubviews()
//        blurEffectView.autoresizingOff()
//        blurEffectView --> self
    }
    
    func addToParent() {
        self.autoresizingOff()
        parent.addSubview(self)
        self.centerXAnchor --> parent.centerXAnchor
        self.centerYAnchor --> parent.centerYAnchor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didMoveOverlayTextView(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: parent)
        guard let overlayTextView = recognizer.view as? UITextView else { return }
        overlayTextView.center = CGPoint(x: overlayTextView.center.x + translation.x, y: overlayTextView.center.y + translation.y)
        recognizer.setTranslation(.zero, in: parent)
        
        
    }
    
    @objc private func didRotateOverlayTextView(recognizer: UIRotationGestureRecognizer) {
        let rotation = recognizer.rotation
        guard let overlayTextView = recognizer.view as? UITextView else { return }
        overlayTextView.transform = overlayTextView.transform.rotated(by: rotation)
        recognizer.rotation = 0
        
    }
    
    @objc func  didPichOverlayTextView(recognizer: UIPinchGestureRecognizer) {
        let scale = recognizer.scale
        guard let overlayTextView = recognizer.view as? UITextView else { return }
        
        let currentTransform = overlayTextView.transform
        overlayTextView.transform = currentTransform.scaledBy(x: scale, y: scale)
        recognizer.scale = 1.0
    }
    
}

extension OverlayTextView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension OverlayTextView:  NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>, lineFragmentUsedRect: UnsafeMutablePointer<CGRect>, baselineOffset: UnsafeMutablePointer<CGFloat>, in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange) -> Bool {
        
        lineFragmentRect.pointee = CGRect(origin: lineFragmentRect.pointee.origin, size: CGSize(width: lineFragmentRect.pointee.size.width, height: lineFragmentRect.pointee.size.height + 10))
        lineFragmentUsedRect.pointee = CGRect(origin: lineFragmentUsedRect.pointee.origin, size: CGSize(width: lineFragmentUsedRect.pointee.size.width, height: lineFragmentUsedRect.pointee.size.height + 10))
        baselineOffset.pointee = lineFragmentUsedRect.pointee.size.height
        return true
    }
}
