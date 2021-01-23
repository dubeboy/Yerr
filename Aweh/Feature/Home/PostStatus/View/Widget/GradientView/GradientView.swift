//
//  GradientView.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/23.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()

    init() {
        super.init(frame: .zero)
        configureGradient()
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) { [self] in
            transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        } completion: { [self] _ in
            transform = .identity
        }
    }
    
}

private extension GradientView {
    private func configureGradient() {
        gradientLayer.frame = bounds
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [UIColor(hex: "f9ed32").cgColor, UIColor(hex: "ee2a7b").cgColor]
        layer.addSublayer(gradientLayer)
    }
}
