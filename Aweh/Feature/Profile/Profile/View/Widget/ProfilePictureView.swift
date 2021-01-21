//
//  ProfilePictureView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/17.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class ProfilePictureView: UIView {
    
    var imageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func borderColor(color: String) {
        layer.borderWidth = Const.View.m4
        layer.borderColor = UIColor(hex: color).cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.makeRound()
    }
    
    func downloadImage(url: String) {
        imageView.downloadImage(fromUrl: url)
    }
}

extension ProfilePictureView {
    private func configureSelf() {
//        backgroundColor = Const.Color.backgroundColor
    }
    
    private func configureImageView() {
        addSubview(imageView)
        imageView.autoresizingOff()
        imageView.topAnchor --> topAnchor + Const.View.m8
        imageView.bottomAnchor --> bottomAnchor + Const.View.m8
        imageView.leadingAnchor --> leadingAnchor + Const.View.m8
        imageView.trailingAnchor --> trailingAnchor + Const.View.m8
    }
    
}
