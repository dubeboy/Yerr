//
//  LikeAndVotesHStask.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class LikeAndVotesVStask: UIStackView {
    
    private var likeButton: BottomLabelButton = BottomLabelButton()
    private var upVoteButton: BottomLabelButton = BottomLabelButton()
    private var downVoteButton: BottomLabelButton = BottomLabelButton()
    
    var didTapLikeAction: (() -> Void)?
    var didTapUpVoteAction: (() -> Void)?
    var didTapDownVoteAction: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        configureSelf()
        configureAndAddButtons()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        axis = .vertical
        distribution = .fillEqually
        spacing = Const.View.m2
        alignment = .center
        spacing = 0
    }
    
    private func configureLikeButton() {
        likeButton.autoresizingOff()
        likeButton.set(image: Const.Assets.Feed.like, text: "-")
    }
    
    private func configureUpVoteButton() {
        upVoteButton.autoresizingOff()
        upVoteButton.set(image: Const.Assets.Feed.upVoteArrow, text: "-")
    }
    
    private func configureDownVoteButton() {
        downVoteButton.autoresizingOff()
        downVoteButton.set(image: Const.Assets.Feed.downVoteArrow, text: "-")
    }
    
    private func configureAndAddButtons() {
        configureLikeButton()
        configureUpVoteButton()
        configureDownVoteButton()
        
        addArrangedSubview(likeButton)
        addArrangedSubview(downVoteButton)
        addArrangedSubview(upVoteButton)
    }
}
