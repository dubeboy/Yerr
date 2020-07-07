//
//  UIView+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

extension UIView {
    func makeRound() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
    }
}

extension UIView {
    func makeImageRound() {
        makeRound()
        contentMode = .scaleAspectFill
        layer.borderWidth = 0.03
        layer.backgroundColor = UIColor.systemGray6.cgColor
    }
}
