//
//  CommentView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CommentBoxView: UIView {
    
    private var containerStackView: UIStackView!
    private var commentTextView: UITextView!
    private var iconsStackView: UIStackView!
    private var selectePhotosButton: UIButton!
    private var replyButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerStackView = UIStackView(frame: .zero)
        
        commentTextView = UITextView(frame: .zero)
        iconsStackView = UIStackView(frame: .zero)
        selectePhotosButton = UIButton(frame: .zero)
        replyButton = UIButton(frame: .zero)
        
        configureSelf()
        configureInputBox()
        configureIconsStackView()
        addIconsToIconsStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupConstraintsForIcons()
        setupConstraintsForCommentsBox()
    }
    
    private func setupConstraintsForIcons() {
        iconsStackView.heightAnchor --> 30
    }
    
    private func setupConstraintsForCommentsBox() {
    }
}

private extension CommentBoxView {
    
    private func configureSelf() {
        self.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.spacing = Const.View.m4
        containerStackView.alignment = .fill
        containerStackView.distribution = .fillProportionally
        addSubview(containerStackView)
        
        containerStackView.bottomAnchor --> self.bottomAnchor + -Const.View.m8
        containerStackView.topAnchor --> self.topAnchor + Const.View.m8
        containerStackView.leadingAnchor --> self.leadingAnchor + Const.View.m16
        containerStackView.trailingAnchor --> self.trailingAnchor + -Const.View.m16
        
        self.addDividerLine(to: [.top])
        self.backgroundColor = Const.Color.systemWhite
    }
    
    private func configureInputBox() {
        containerStackView.addArrangedSubview(commentTextView)
        commentTextView.isScrollEnabled = false // Allows automatic height adjustment
        commentTextView.backgroundColor = Const.Color.lightGray
        commentTextView.layer.cornerRadius = Const.View.radius
        
    }
    
    private func configureIconsStackView() {
        iconsStackView.axis = .horizontal
        iconsStackView.spacing = Const.View.m4
        iconsStackView.alignment = .fill
        iconsStackView.distribution = .equalSpacing
        containerStackView.addArrangedSubview(iconsStackView)
    }
    
    private func addIconsToIconsStackView() {
        selectePhotosButton.setTitle("Photo", for: .normal)
        selectePhotosButton.backgroundColor = .cyan
        iconsStackView.addArrangedSubview(selectePhotosButton)
        replyButton.backgroundColor = .blue
        replyButton.setTitle("Reply", for: .normal)
        iconsStackView.addArrangedSubview(replyButton)
    }
}
