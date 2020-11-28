//
//  TrimPostStatusBoderView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class TrimPostStatusBoderView: UIView {
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let bundle = Bundle(for: TrimPostStatusBoderView.self)
        let image = UIImage(named: "BorderLine", in: bundle, compatibleWith: nil)
        
        imageView.frame = self.bounds
        imageView.image = image
        imageView.contentMode = .scaleToFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
}
