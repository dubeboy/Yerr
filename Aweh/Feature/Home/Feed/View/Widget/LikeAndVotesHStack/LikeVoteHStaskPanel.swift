//
//  LikeAndVotesHStask.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class LikeAndVotesVStask: UIView {
    
    @LateInit
    private var constainerStackView: UIStackView
    @LateInit
    private var likeButton: BottomLabelButton
    @LateInit
    private var upVoteButton: BottomLabelButton
    @LateInit
    private var downVoteButton: BottomLabelButton
    
    var didTapLikeAction: (() -> Void)?
    var didTapUpVoteAction: (() -> Void)?
    var didTapDownVoteAction: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        constainerStackView = UIStackView()
        likeButton = BottomLabelButton(frame: .zero)
        upVoteButton = BottomLabelButton(frame: .zero)
        downVoteButton = BottomLabelButton(frame: .zero)
        configureSelf()
        configureAndAddButtons()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constainerStackView.translatesAutoresizingMaskIntoConstraints = false
        constainerStackView --> self
        
    }
    
    @objc private func didTapLikeButtonTarget() {
        didTapLikeAction?()
    }
    
    @objc private func didTapUpVoteButton() {
        didTapUpVoteAction?()
    }
    
    @objc private func didTapDownVoteButton() {
        didTapDownVoteAction?()
    }
    
    func setUpVoteText(text: String) {
        upVoteButton.setText(text: text)
    }
    
    func setDownVoteText(text: String) {
        downVoteButton.setText(text: text)
    }
    
    func setLikeVoteText(text: String) {
        likeButton.setText(text: text)
    }
}

// MARK: helper functions
extension LikeAndVotesVStask {
    private func configureSelf() {
        constainerStackView.axis = .vertical
        constainerStackView.distribution = .fillEqually
        constainerStackView.spacing = Const.View.m2
        constainerStackView.alignment = .center
        constainerStackView.spacing = 0
        
        addSubview(constainerStackView)
    }
    
    private func configureLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.set(image: Const.Assets.Feed.like, text: "-")
        likeButton.action = didTapLikeAction
    }
    
    private func configureUpVoteButton() {
        upVoteButton.translatesAutoresizingMaskIntoConstraints = false
        upVoteButton.set(image: Const.Assets.Feed.upVoteArrow, text: "-")
        upVoteButton.action = didTapUpVoteAction
    }
    
    private func configureDownVoteButton() {
        downVoteButton.translatesAutoresizingMaskIntoConstraints = false
        downVoteButton.set(image: Const.Assets.Feed.downVoteArrow, text: "-")
        downVoteButton.action = didTapDownVoteAction
    }
    
    private func configureAndAddButtons() {
        configureLikeButton()
        configureUpVoteButton()
        configureDownVoteButton()
        
        constainerStackView.addArrangedSubview(likeButton)
        constainerStackView.addArrangedSubview(downVoteButton)
        constainerStackView.addArrangedSubview(upVoteButton)        
    }
}
