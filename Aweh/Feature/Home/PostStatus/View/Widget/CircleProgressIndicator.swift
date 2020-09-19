//
//  CircleProgressIndicator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/16.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CircleProgressIndicator: UIView {
    
    private var animatableBorderLayer: BorderLayer!
    private var trackLayer: BorderLayer!
    private var centeredLabel: UILabel!
    private var trackSize = Const.View.m4 + 2
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        animatableBorderLayer = createTrackLayer()
        trackLayer = createBackgroundTrackLayer()
        centeredLabel = UILabel()
        centeredLabel.center = self.center
        centeredLabel.text = "0"
        addSubview(centeredLabel)
        layer.addSublayer(trackLayer)
        layer.addSublayer(animatableBorderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        frame.insetBy(
//            dx: animatableBorderLayer.lineWidth,
//            dy: animatableBorderLayer.lineWidth
//        )
        centeredLabel.center = center
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
        trackBackgroundLayer.endRadAngle = .toRad(angle: 360)
        trackBackgroundLayer.lineColor = Const.Color.Feed.trackBackGroundColor.cgColor
        return trackBackgroundLayer
    }
    
    /// update progress in percentage units
    func updateProgress(percent: CGFloat) {
        let degrees: CGFloat = (percent / 100.0) * 360.0
        centeredLabel.text = "\(percent)"
        animatableBorderLayer.endRadAngle = .toRad(angle: degrees)
        setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
