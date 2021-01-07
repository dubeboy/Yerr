//
//  UITextView+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/01.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

extension UITextView {
    
    func centerVerticalText() {
        self.textAlignment = .center
        let fitSize = CGSize(width: bounds.width, height: bounds.height)
        let size = sizeThatFits(fitSize)
        let calculate = (bounds.size.height - size.height * zoomScale) / 2
        let offset = max(1, calculate)
        contentOffset.y = -offset
    }
}
