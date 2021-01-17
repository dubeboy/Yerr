//
//  YerrButton.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol YerrButtonDelegate: AnyObject {
    func startAnimate(tag: Int)
    func endAnimate(tag: Int)
}

class YerrButton: UIButton {
    
    private static let buttonEdgeInset: UIEdgeInsets = .equalEdgeInsets(Const.View.m8)
    weak var delegate: YerrButtonDelegate? = nil
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSelf()
    }
    
    func setImage(fillBoundsWith image: UIImage?, for state: UIControl.State = .normal) {
        setImage(image, for: state)
        contentMode = .scaleAspectFit
        imageEdgeInsets = .zero
        contentEdgeInsets = .zero
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = false

    }
    
//    @objc var delegate: (() -> Void)? {
//        didSet {
//            addTarget(self, action: #selector(getter: delegate), for: .touchUpInside)
//        }
//    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        UIView.animate(withDuration: 0.3) {
//            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            self.titleLabel?.alpha = 0.7
//        }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        UIView.animate(withDuration: 0.3) {
//            self.transform = .identity
//            self.titleLabel?.alpha = 1
//        }
//    }
    
    @objc private func tipTapViewAnimate(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) { [self] in
            transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            delegate?.startAnimate(tag: tag)
        } completion: { [self] _ in
            transform = .identity
            delegate?.endAnimate(tag: tag)
        }
    }
}

extension YerrButton {
    private func configureSelf() {
        addTarget(self, action: #selector(tipTapViewAnimate(_:)), for: .touchUpInside)
    }
}
