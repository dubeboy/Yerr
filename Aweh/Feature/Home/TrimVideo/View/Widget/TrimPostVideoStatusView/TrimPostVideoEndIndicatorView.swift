//
//  TrimPostVideoEndIndicator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class TrimPostVideoEndIndicatorView: UIView {
    
    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        let bundle = Bundle(for: Self.self)
        let image = UIImage(named: "EndIndicator", in: bundle, compatibleWith: nil)
        imageView.frame = self.bounds
        imageView.image = image
        imageView.contentMode = .scaleToFill
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
}
