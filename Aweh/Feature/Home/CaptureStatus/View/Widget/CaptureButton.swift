//
//  CaptureButton.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CaptureButton: YerrButton {
        
    init() {
        super.init(frame: .zero)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = bounds.width / 2
        self.layer.borderWidth = Const.View.m4 + 2
        self.layer.borderColor = Const.Color.CaptureStatus.captureButton.cgColor
    }
    
    func setVideoClickAction(action: Completion<()>) {
        //
    }
}

// MARK: private functions
private extension CaptureButton {
    private func configureSelf() {
        self.backgroundColor = .clear
       
    }
}
