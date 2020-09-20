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
    var constainerStackView: UIStackView
    @LateInit
    var likeButton: YerrButton
    @LateInit
    var upVoteButton: UIButton
    @LateInit
    var downVoteButton: UIButton
    
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
//        likeButton.setTitle(AppStrings.Feed.likeButton, for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(Const.Assets.Feed.like, for: .normal)
    }
    
    private func configureUpVoteButton() {
        //        likeButton.setTitle(AppStrings.Feed.likeButton, for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        upVoteButton.setImage(Const.Assets.Feed.upVoteArrow, for: .normal)
    }
    
    private func configureDownVoteButton() {
        //        likeButton.setTitle(AppStrings.Feed.likeButton, for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        downVoteButton.setImage(Const.Assets.Feed.downVoteArrow, for: .normal)
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
