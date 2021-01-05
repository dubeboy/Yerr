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
    
    init(parent: UIView, backgroundColor: UIColor = .cyan, tag: Int = 0) {
        self.parent = parent
        super.init(frame: .zero, textContainer: nil)
                
        self.backgroundColor = backgroundColor.withAlphaComponent(0.6)
        self.isScrollEnabled = false
        self.tag = tag
        self.textAlignment = .center
        self.sizeToFit()
        
        self.addShadow()
        self.layer.cornerRadius = Const.View.radius
        let blurEffect = UIBlurEffect(style: .prominent)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.frame
        blurEffectView.clipsToBounds = true
//        blurEffectView.autoresizingOff()

        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didMoveOverlayTextView(recognizer:)))
        self.addGestureRecognizer(panGesture)
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateOverlayTextView(recognizer:)))
        self.addGestureRecognizer(rotationGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self , action: #selector(didPichOverlayTextView(recognizer:)))
        self.addGestureRecognizer(pinchGesture)
        
        panGesture.delegate = self
        rotationGesture.delegate = self
        pinchGesture.delegate = self
        
        // add dymanic font too so that when the view inccrease al the text increases
        // add a hit test to see what the user is trying to do and assign that action this view
        // animatye gestures when below the keyboad
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.autoresizingOff()
        blurEffectView --> self
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
