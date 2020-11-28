//
//  CaptureButton.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CaptureButton: UIButton {
    
    private let borderLayer: BorderLayer = BorderLayer()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        configureSelf()
        configureBorderLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = bounds
    }
}

// MARK: private functions
private extension CaptureButton {
    private func configureSelf() {
        self.backgroundColor = .clear
        
    }
    
    private func configureBorderLayer() {
        borderLayer.lineWidth = Const.View.m4
        borderLayer.endRadAngle = .toRadNormalized(angle: 360)
        borderLayer.lineColor = Const.Color.CaptureStatus.captureButton.cgColor
        layer.addSublayer(borderLayer)
    }
}
