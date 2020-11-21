//
//  BottomLabelButton.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/21.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class BottomLabelButton: UIView {
    
    var imageView: UIImageView = UIImageView()
    var label = UILabel()
    var containerStackView = UIStackView()
    var action: (() -> Void)? = nil {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAction))
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    @objc func didTapAction() {
        action?()
    }
    
}

extension BottomLabelButton {
    private func configureSelf() {
        containerStackView.autoresizingOff()
        addSubview(containerStackView)
        containerStackView.distribution = .fillProportionally
        containerStackView.axis = .vertical
        containerStackView.alignment = .top
        containerStackView.spacing = Const.View.m1
        imageView.autoresizingOff()
        imageView.widthAnchor --> 22
        imageView.heightAnchor --> 22
        label.textAlignment = .center
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(label)
    }
}
