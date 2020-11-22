//
//  BottomLabelButton.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/21.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class BottomLabelButton: UIView {
    
    let imageView: UIImageView
    private let label = UILabel()
    private var containerStackView = UIStackView()
//    var action: (() -> Void)? = nil {
//        didSet {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAction))
//            self.addGestureRecognizer(tapGesture)
//        }
//    }
    
    init() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
//        imageView.backgroundColor = .red
//        label.backgroundColor = .gray
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

extension BottomLabelButton {
    private func configureSelf() {
        containerStackView.autoresizingOff()
        addSubview(containerStackView)
        containerStackView.distribution = .fillEqually
        containerStackView.axis = .vertical
        containerStackView.alignment = .top
        containerStackView.spacing = Const.View.m1
        
        containerStackView --> self
        
        label.autoresizingOff()
        imageView.autoresizingOff()
        
        label.textAlignment = .center
        label.numberOfLines = 1
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(label)
    }
}
