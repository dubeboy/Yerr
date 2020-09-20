//
//  HelloPeoiple.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class LikeAndVotesHStask: UIStackView {
    
    @LateInit
    var likeButton: UIButton
    @LateInit
    var upVoteButton: UIButton
    @LateInit
    var downVoteButton: UIButton
    
    init() {
        super.init(frame: .zero)
        configureSelf()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: helper functions
extension LikeAndVotesHStask {
    private func configureSelf() {
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .trailing
        self.spacing = Const.View.m8
    }
    
//    private func configureLikeButton() {
//        likeButton.te
//    }
}
