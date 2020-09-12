//
//  CommentView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CommentBoxView: UIStackView {
    var commentTextView: UITextView!
    var iconsStackView: UIStackView!
    var selectePhotosButton: UIButton!
    var replyButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commentTextView = UITextView(frame: .zero)
        commentTextView.backgroundColor = .darkGray
        iconsStackView = UIStackView(frame: .zero)
        selectePhotosButton = UIButton(frame: .zero)
        replyButton = UIButton(frame: .zero)
        
        configureInputBox()
        configureIconsStackView()
        addIconsToIconsStackView()
    }
    
    private func configureInputBox() {
        axis = .vertical
        spacing = Const.View.m2
        alignment = .fill
        distribution = .fillProportionally
        addArrangedSubview(commentTextView)
        
        commentTextView.isScrollEnabled = false // Allows automatic height adjust menty
    }
    
    private func configureIconsStackView() {
        iconsStackView.axis = .horizontal
        iconsStackView.spacing = Const.View.m4
        iconsStackView.alignment = .fill
        iconsStackView.distribution = .equalSpacing
        addArrangedSubview(iconsStackView)
    }
    
    private func addIconsToIconsStackView() {
        selectePhotosButton.setTitle("Photo", for: .normal)
        selectePhotosButton.backgroundColor = .cyan
        iconsStackView.addArrangedSubview(selectePhotosButton)
        replyButton.backgroundColor = .blue
        replyButton.setTitle("Reply", for: .normal)
        iconsStackView.addArrangedSubview(replyButton)
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
