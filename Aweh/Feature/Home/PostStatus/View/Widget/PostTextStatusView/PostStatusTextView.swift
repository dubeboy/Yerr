//
//  PostStatusView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/22.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class PostStatusTextView: UIView {
    
    var statusTextView = UITextView()
    
    init() {
        super.init(frame: .zero)
        configureStatusTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFont(font: UIFont) {
        
    }
    
    func setBackgroundColor(color: UIColor) {
        // set the background color for the attributed text
        // https://levelup.gitconnected.com/background-with-rounded-corners-in-uitextview-1c095c708d14
        // also enable gradient colors
    }
}

private extension PostStatusTextView {
    private func configureSelf() {
        
    }
    
    private func configureStatusTextView() {
        statusTextView.autoresizingOff()
        addSubview(statusTextView)
        statusTextView.textAlignment = .center
        statusTextView --> self
    }
}
