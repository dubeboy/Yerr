//
//  YerrButton.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class YerrButton: UIButton {
    
    private static let buttonEdgeInset = UIEdgeInsets(top: Const.View.m8, left: Const.View.m8, bottom: Const.View.m8, right: Const.View.m8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YerrButton {
    private func configureSelf() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(Const.Color.lightGray, for: .highlighted)
        self.setTitleColor(Const.Color.lightGray, for: .selected)
        self.layer.cornerRadius = Const.View.radius
        self.layer.masksToBounds = true
        self.contentEdgeInsets = Self.buttonEdgeInset
    }
}