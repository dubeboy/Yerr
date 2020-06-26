//
//  StatusIndicator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

class StatusIndicator: UIProgressView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        progress = 0.0
//        self.transform.scaledBy(x: 1, y: 4)
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.sublayers![1].cornerRadius = 10
        subviews[1].clipsToBounds = true
        
//        progressTintColor =
//        trackTintColor =
    }
}
