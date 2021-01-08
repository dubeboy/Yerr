//
//  YerrButton.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class YerrButton: UIButton {
    
    private static let buttonEdgeInset: UIEdgeInsets = .equalEdgeInsets(Const.View.m8)

    override func layoutSubviews() {
        super.layoutSubviews()
        configureSelf()
    }
    
    func setImage(fillBoundsWith image: UIImage?, for state: UIControl.State = .normal) {
        setImage(image, for: state)
        contentMode = .scaleToFill
        imageEdgeInsets = .zero
        contentEdgeInsets = .zero
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        imageView?.contentMode = .scaleToFill
        imageView?.clipsToBounds = false
    }
    
//    @objc var delegate: (() -> Void)? {
//        didSet {
//            addTarget(self, action: #selector(getter: delegate), for: .touchUpInside)
//        }
//    }
}

extension YerrButton {
    private func configureSelf() {
//        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(Const.Color.lightGray, for: .highlighted)
        self.setTitleColor(Const.Color.lightGray, for: .selected)
        self.layer.cornerRadius = Const.View.radius
        self.layer.masksToBounds = true
        self.contentEdgeInsets = Self.buttonEdgeInset
    }
}
