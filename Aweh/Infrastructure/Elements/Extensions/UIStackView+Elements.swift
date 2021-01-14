//
//  UIStackView+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/21.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints) // https://stackoverflow.com/questions/41054308/swift-crash-on-removefromsuperview
            $0.removeFromSuperview()
        }
    }
}

