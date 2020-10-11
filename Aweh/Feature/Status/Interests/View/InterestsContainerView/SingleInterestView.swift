//
//  SingleInterestView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class SingleInterestView: UIView {
    private let label: UILabel = UILabel(frame: .zero)
    
    var interest: String = "" {
        didSet {
            label.text = interest
            backgroundColor = .random(from: interest)
        }
    }
    
    init() {
        super.init(frame: .zero)
        configureSelf()
        congfigureIntrestLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SingleInterestView {
    
    private func configureSelf() {
        layer.cornerRadius = Const.View.radius
        addShadow()
    }
    
    private func congfigureIntrestLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.leadingAnchor --> self.leadingAnchor
        label.trailingAnchor --> self.trailingAnchor + -Const.View.m8
        label.bottomAnchor --> self.bottomAnchor + -Const.View.m8
    }
}
