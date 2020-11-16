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
    
    func setUpVoteText(text: String) {
        upVoteButton.setTitle(text, for: .normal)
        likeButton.setTitleColor(.label, for: .normal)
    }
    
    func setDownVoteText(text: String) {
        downVoteButton.setTitle(text, for: .normal)
        likeButton.setTitleColor(.label, for: .normal)
    }
    
    func setLikeVoteText(text: String) {
        likeButton.setTitle(text, for: .normal)
        likeButton.setTitleColor(.label, for: .normal)
//        likeButton.imageEdgeInsets.left = -50
    }
}

// MARK: helper functions
extension LikeAndVotesVStask {
    private func configureSelf() {
        constainerStackView.axis = .vertical
        constainerStackView.distribution = .fillEqually
        constainerStackView.alignment = .fill
        constainerStackView.spacing = Const.View.m8
        widthAnchor --> 40
        constainerStackView.widthAnchor --> 40
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
