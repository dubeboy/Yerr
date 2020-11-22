//
//  BottomLabelButton.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/21.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class BottomLabelButton: UIView {
    
    private let imageView: UIImageView
    private let label = UILabel()
    private let containerStackView = UIStackView()
    var action: (() -> Void)? = nil
//    var action: (() -> Void)? = nil {
//        didSet {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAction))
//            self.addGestureRecognizer(tapGesture)
//        }
//    }
    
    init() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        super.init(frame: .zero)
        configureSelf()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: UIImage?, text: String) {
        imageView.image = image
        label.text = text
    }
    
    func setText(text: String) {
        label.text = text
    }
}

private extension BottomLabelButton {
    private func configureSelf() {
        containerStackView.autoresizingOff()
        addSubview(containerStackView)
        containerStackView.distribution = .fillEqually
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.spacing = Const.View.m1
        
        containerStackView --> self
        
        label.autoresizingOff()
//        label.heightAnchor --> 22
        imageView.autoresizingOff()
        
        label.textAlignment = .center
        label.numberOfLines = 1
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(label)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func didTapButton() {
        action?()
    }
}
