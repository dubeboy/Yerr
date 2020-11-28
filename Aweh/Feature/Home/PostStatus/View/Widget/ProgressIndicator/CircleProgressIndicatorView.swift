//
//  CircleProgressIndicator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/16.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CircleProgressIndicatorView: UIView {
    
    private var animatableBorderLayer: BorderLayer!
    private var trackLayer: BorderLayer!
    private var centeredLabel: UILabel!
    private var trackSize = Const.View.m4 + 2
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        animatableBorderLayer = createTrackLayer()
        trackLayer = createBackgroundTrackLayer()
        configureCenterLabel()
        addSubview(centeredLabel)
        layer.addSublayer(trackLayer)
        layer.addSublayer(animatableBorderLayer)
    }
    
    private func configureCenterLabel() {
        centeredLabel = UILabel()
        centeredLabel.translatesAutoresizingMaskIntoConstraints = false
        centeredLabel.text = ""
        centeredLabel.adjustsFontSizeToFitWidth = true
        centeredLabel.numberOfLines = 1
        centeredLabel.minimumScaleFactor = 0.1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        centeredLabel.topAnchor --> topAnchor + trackSize * 2
        centeredLabel.bottomAnchor --> bottomAnchor + -(trackSize * 2.5) // TODO: this is a hack to put the text in the center
        centeredLabel.leadingAnchor --> leadingAnchor + trackSize * 2
        centeredLabel.trailingAnchor --> trailingAnchor + -(trackSize * 2)
        centeredLabel.centerYAnchor --> centerYAnchor
        centeredLabel.centerXAnchor --> centerXAnchor
        centeredLabel.textAlignment = .center
        animatableBorderLayer.frame = bounds
        trackLayer.frame = bounds
        animatableBorderLayer.setNeedsDisplay()
        trackLayer.setNeedsDisplay()
    }
    
    private func createTrackLayer() -> BorderLayer {
        animatableBorderLayer = BorderLayer()
        animatableBorderLayer.lineWidth = trackSize
        animatableBorderLayer.lineColor = Const.Color.Feed.trackColor.cgColor
        return animatableBorderLayer
    }
    
    private func createBackgroundTrackLayer() -> BorderLayer {
        let trackBackgroundLayer = BorderLayer()
        trackBackgroundLayer.lineWidth = trackSize
        trackBackgroundLayer.endRadAngle = .toRadNormalized(angle: 360)
        trackBackgroundLayer.lineColor = Const.Color.Feed.trackBackGroundColor.cgColor
        return trackBackgroundLayer
    }
    
    /// update progress in percentage units
    func updateProgress(percent: CGFloat) {
        
        let degrees: CGFloat = (percent / 100.0) * 360.0
        animatableBorderLayer.endRadAngle = .toRadNormalized(angle: degrees)
        
    }
    
    func updateProgressLabel(text: String) {
        centeredLabel.text = text
    }
    
    func updateProgressRingColor(color: UIColor) {
        animatableBorderLayer.lineColor = color.cgColor
    }
    
    func resetColors() {
        animatableBorderLayer.lineColor = Const.Color.Feed.trackColor.cgColor
        centeredLabel.textColor = Const.Color.Feed.textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
