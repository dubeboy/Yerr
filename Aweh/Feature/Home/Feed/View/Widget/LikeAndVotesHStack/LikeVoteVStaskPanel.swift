//
//  LikeAndVotesHStask.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class LikeAndVotesVStask: UIStackView {
    
    private let likeButton = YerrButton()
    private let upVoteButton = YerrButton()
    private let downVoteButton = YerrButton()
    
    private let likeButtonText = UILabel()
    private let upVoteButtonText = UILabel()
    private let downVoteButtonText = UILabel()
        
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
    
    func setUpVoteText(text: String) {
        upVoteButtonText.text = text
    }
    
    func setDownVoteText(text: String) {
        downVoteButtonText.text = text
    }
    
    func setLikeVoteText(text: String) {
        likeButtonText.text = text
    }
    
    @objc private func didTapLikeButton() {
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
private extension LikeAndVotesVStask {
    private func configureSelf() {
        axis = .vertical
        distribution = .fillProportionally
        spacing = Const.View.m16
        alignment = .fill
    }
    
    private func configureLikeButton() {
        likeButton.autoresizingOff()
        let image = Const.Assets.Feed.like?.withRenderingMode(.alwaysTemplate)
        likeButton.setImage(fillBoundsWith: image)
        likeButton.addShadow(offest: 0.5, color: UIColor.black.withAlphaComponent(0.7))
        upVoteButton.tintColor = .white
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        likeButton.delegate = self
        likeButton.tag = 0
//        likeButton.action = { [weak self] in
//            self?.didTapLikeAction?()
//        }
    }
    
    private func configureUpVoteButton() {
        upVoteButton.autoresizingOff()
        upVoteButton.setImage(fillBoundsWith: Const.Assets.Feed.upVoteArrow)
        upVoteButton.addShadow(offest: 0.5, color: UIColor.black.withAlphaComponent(0.7))
        upVoteButton.tintColor = .white
        upVoteButton.addTarget(self, action: #selector(didTapUpVoteButton), for: .touchUpInside)
        upVoteButton.delegate = self
        upVoteButton.tag = 1
    }
    
    private func configureDownVoteButton() {
        downVoteButton.autoresizingOff()
        downVoteButton.setImage(fillBoundsWith: Const.Assets.Feed.downVoteArrow)
        downVoteButton.addShadow(offest: 0.5, color: UIColor.black.withAlphaComponent(0.7))
        downVoteButton.tintColor = .white
        downVoteButton.addTarget(self, action: #selector(didTapDownVoteButton), for: .touchUpInside)
        upVoteButton.delegate = self
        upVoteButton.tag = 2
    }
    
    private func configureLabels(labels: UILabel...) {
        
        labels.forEach { label in
           label.autoresizingOff()
           label.textAlignment = .center
           label.heightAnchor --> 15
           label.text = "0"
           label.textColor = .white
           label.addShadow(offest: 1, color: UIColor.black.withAlphaComponent(0.7))
           let font = UIFont.preferredFont(forTextStyle: .footnote)
           label.font = font

           label.adjustsFontForContentSizeCategory = true
        }
    }
    
    private func createButtonAndLabelStackView() -> UIStackView {
        let buttonAndLabeStackView = UIStackView()
        buttonAndLabeStackView.autoresizingOff()
        buttonAndLabeStackView.axis = .vertical
        buttonAndLabeStackView.distribution = .fillProportionally
        buttonAndLabeStackView.alignment = .fill
        buttonAndLabeStackView.spacing = 0
        return buttonAndLabeStackView
    }
    
    
    private func configureAndAddButtons() {
        configureLikeButton()
        configureUpVoteButton()
        configureDownVoteButton()
        configureLabels(labels: likeButtonText, upVoteButtonText, downVoteButtonText)
        
        
        let likeButtonGroupStack = createButtonAndLabelStackView()
        
        likeButtonGroupStack.addArrangedSubview(likeButton)
        likeButtonGroupStack.addArrangedSubview(likeButtonText)
        addArrangedSubview(likeButtonGroupStack)
        
        let downVoteButtonGroup = createButtonAndLabelStackView()
        downVoteButtonGroup.addArrangedSubview(downVoteButton)
        downVoteButtonGroup.addArrangedSubview(downVoteButtonText)
        addArrangedSubview(downVoteButtonGroup)
        
        let upVoteButtonGroup = createButtonAndLabelStackView()
        upVoteButtonGroup.addArrangedSubview(upVoteButton)
        upVoteButtonGroup.addArrangedSubview(upVoteButtonText)
        addArrangedSubview(upVoteButtonGroup)

//        UIColor.red.withAlphaComponent(0.6)
        likeButton.widthAnchor --> 40
        likeButton.heightAnchor --> 40
        likeButton.tintColor = UIColor.white.withAlphaComponent(1)
        
        downVoteButton.widthAnchor --> 40
        downVoteButton.heightAnchor --> 40
        downVoteButton.tintColor = .white
        
        upVoteButton.widthAnchor --> 40
        upVoteButton.heightAnchor --> 40
        upVoteButton.tintColor = .white
        
    }
}

// MARK: - Yerr button delegate

extension LikeAndVotesVStask: YerrButtonDelegate {
    func startAnimate(tag: Int) {
        UIView.animate(withDuration: 0.2) { [self] in
            switch tag {
                case 0:
                    likeButtonText.alpha = 0.7
                case 1:
                    upVoteButtonText.alpha = 0.7
                case 2:
                    downVoteButtonText.alpha = 0.7
                default:
                    break
            }
        }
    }
    
    func endAnimate(tag: Int) {
        UIView.animate(withDuration: 0.2) { [self] in
            switch tag {
                case 0:
                    
                    likeButtonText.alpha = 1
                case 1:
                    upVoteButtonText.alpha = 1
                case 2:
                    downVoteButtonText.alpha = 1
                default:
                    break
            }
        }
    }
}
