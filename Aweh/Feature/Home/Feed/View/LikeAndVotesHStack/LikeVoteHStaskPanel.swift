//
//  LikeAndVotesHStask.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class LikeAndVotesHStask: UIView {
    
    @LateInit
    private var constainerStackView: UIStackView
    @LateInit
    private var likeButton: YerrButton
    @LateInit
    private var upVoteButton: YerrButton
    @LateInit
    private var downVoteButton: YerrButton
    
    var didTapLikeAction: (() -> Void)?
    var didTapUpVoteAction: (() -> Void)?
    var didTapDownVoteAction: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        constainerStackView = UIStackView()
        likeButton = YerrButton(frame: .zero)
        upVoteButton = YerrButton(frame: .zero)
        downVoteButton = YerrButton(frame: .zero)
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
}

// MARK: helper functions
extension LikeAndVotesHStask {
    private func configureSelf() {
        constainerStackView.axis = .horizontal
        constainerStackView.distribution = .fillEqually
        constainerStackView.alignment = .fill
        constainerStackView.spacing = Const.View.m8
        heightAnchor --> 40
        constainerStackView.heightAnchor --> 40
        addSubview(constainerStackView)
    }
    
    private func configureLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(Const.Assets.Feed.like, for: .normal)
        likeButton.addTarget(self, action: #selector(didTapLikeButtonTarget), for: .touchUpInside)
    }
    
    private func configureUpVoteButton() {
        //        likeButton.setTitle(AppStrings.Feed.likeButton, for: .normal)
        upVoteButton.translatesAutoresizingMaskIntoConstraints = false
        upVoteButton.setImage(Const.Assets.Feed.upVoteArrow, for: .normal)
        upVoteButton.addTarget(self, action: #selector(didTapUpVoteButton), for: .touchUpInside)
    }
    
    private func configureDownVoteButton() {
        //        likeButton.setTitle(AppStrings.Feed.likeButton, for: .normal)
        downVoteButton.translatesAutoresizingMaskIntoConstraints = false
        downVoteButton.setImage(Const.Assets.Feed.downVoteArrow, for: .normal)
        downVoteButton.addTarget(self, action: #selector(didTapDownVoteButton), for: .touchUpInside)
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
