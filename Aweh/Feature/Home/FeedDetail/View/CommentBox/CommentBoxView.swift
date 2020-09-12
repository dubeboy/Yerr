//
//  CommentView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CommentBoxView: UIStackView {
    var commentTextView: UITextField!
    var iconsView: UIStackView!
    var selectePhotosButton: UIButton!
    var replyButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commentTextView = UITextField(frame: .zero)
        commentTextView.backgroundColor = .darkGray
        iconsView = UIStackView(frame: .zero)
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
        distribution = .fillEqually
        addArrangedSubview(commentTextView)
    }
    
    private func configureIconsStackView() {
        iconsView.axis = .horizontal
        iconsView.spacing = Const.View.m4
        iconsView.alignment = .fill
        iconsView.distribution = .equalSpacing
        addArrangedSubview(iconsView)
    }
    
    private func addIconsToIconsStackView() {
        selectePhotosButton.setTitle("Photo", for: .normal)
        selectePhotosButton.backgroundColor = .cyan
        iconsView.addArrangedSubview(selectePhotosButton)
        replyButton.backgroundColor = .blue
        replyButton.setTitle("Reply", for: .normal)
        iconsView.addArrangedSubview(replyButton)
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
//        replyButton.widthAnchor --> 30
//        replyButton.heightAnchor --> 30
    }
    
    private func setupConstraintsForCommentsBox() {
        commentTextView.heightAnchor --> 40
    }
}
