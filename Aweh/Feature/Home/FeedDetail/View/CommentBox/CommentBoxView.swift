//
//  CommentView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class CommentBoxView: UIView {
    
    private static let buttonEdgeInset = UIEdgeInsets(top: Const.View.m8, left: Const.View.m8, bottom: Const.View.m8, right: Const.View.m8)
    
    private var containerStackView: UIStackView!
    private var commentTextView: UITextView! // highlight #helo etc
    private var iconsStackView: UIStackView!
    private(set) var selectePhotosButton: UIButton!
    private(set) var replyButton: UIButton!
    
    init() {
        super.init(frame: .zero)
        containerStackView = UIStackView(frame: .zero)
        
        commentTextView = UITextView(frame: .zero)
        iconsStackView = UIStackView(frame: .zero)
        selectePhotosButton = UIButton(type: .custom)
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
    
    func commentText() -> String {
        commentTextView.text
    }
}

private extension CommentBoxView {
    
    private func configureSelf() {
        self.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.spacing = Const.View.m8
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
        commentTextView.layer.cornerRadius = 1.5 * Const.View.radius
        commentTextView.textContainerInset.left = (1.5 * Const.View.radius) / 2
        commentTextView.textContainerInset.right = (1.5 * Const.View.radius) / 2
        
    }
    
    private func configureIconsStackView() {
        iconsStackView.axis = .horizontal
        iconsStackView.spacing = Const.View.m4
        iconsStackView.alignment = .center
        iconsStackView.distribution = .equalSpacing
        containerStackView.addArrangedSubview(iconsStackView)
    }
    
    private func addIconsToIconsStackView() {
        configurePhotosButton(button: selectePhotosButton)
        iconsStackView.addArrangedSubview(selectePhotosButton)
        configureReplyButton(button: replyButton)
        iconsStackView.addArrangedSubview(replyButton)
    }
    
    private func configureReplyButton(button: UIButton) {
        button.setTitle(AppStrings.FeedDetail.replyButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Const.Color.actionButtonColor
        button.setTitleColor(Const.Color.lightGray, for: .highlighted)
        button.setTitleColor(Const.Color.lightGray, for: .selected)
        button.layer.cornerRadius = Const.View.radius
        button.layer.masksToBounds = true
        button.contentEdgeInsets = Self.buttonEdgeInset
    }
    
    private func configurePhotosButton(button: UIButton) {
        selectePhotosButton.setImage(Const.Assets.FeedDetail.iconImage, for: .normal)
        selectePhotosButton.tintColor = Const.Color.actionButtonColor
        // TODO: fix selectde| higlighted states for tinted image
        button.contentEdgeInsets = Self.buttonEdgeInset
        button.layer.borderWidth = Const.View.borderWidth
        button.layer.masksToBounds = true
        button.layer.borderColor = Const.Color.lightGray.cgColor
        button.layer.cornerRadius = Const.View.radius
    }
    
    // TODO: to be used for do something awesome one day!!!
    private func setupConstraintsForIcons() {
        //        iconsStackView.heightAnchor --> 30
    }
    
    private func setupConstraintsForCommentsBox() {
    }
}
