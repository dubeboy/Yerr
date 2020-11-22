//
//  HomeScreenCollectionViewCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/03.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var canvas: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var songsView: UIView!
    @IBOutlet weak var circlesView: UIView!
    @IBOutlet weak var circlesContainer: UIView!
    
    var likeAndUpVoteVStack: LikeAndVotesVStask = LikeAndVotesVStask()
    
    var statusesView: StatusesView = StatusesView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        configureCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setViewModel(viewModel: StatusPageViewModel) {
        statusesView.setViewModel(viewModel: viewModel)
    }
}

extension FeedCollectionViewCell {
    private func configureCell() {
        configureContentView()
        configureProfileImage()
        configureLikeAndUpVoteButtons()
        configureCirclesContainer()
        configureStatusesView()
    }
    
    private func configureStatusesView() {
        statusesView.autoresizingOff()
        canvas.addSubview(statusesView)
        statusesView --> canvas
    }
    
    private func configureCirclesContainer() {
        circlesContainer.layer.cornerRadius = Const.View.radius
        circlesContainer.backgroundColor = Const.Color.lightGray
    }
    
    private func configureProfileImage() {
        profileImage.makeImageRound()
    }
    
    private func configureLikeAndUpVoteButtons() {
        likeAndUpVoteVStack.autoresizingOff()
        contentView.addSubview(likeAndUpVoteVStack)
        likeAndUpVoteVStack.bottomAnchor --> contentView.bottomAnchor
        likeAndUpVoteVStack.trailingAnchor --> contentView.trailingAnchor + -Const.View.m8
    }
}
