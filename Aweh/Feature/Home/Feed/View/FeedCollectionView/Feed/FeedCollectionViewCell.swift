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
    
    let statusesView: StatusesView = StatusesView()
    let mediaStatus = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        configureCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaStatus.isHidden = true
    }
    
    func setViewModel(viewModel: StatusPageViewModel) {
        statusesView.setViewModel(viewModel: viewModel)
    }
    
    func setMediaText(text: String) {
        mediaStatus.isHidden = false
        mediaStatus.text = text
    }
    
    // the below function need some api work
    func markVotedOnStatus() {
        
    }
    
    func markLikedStatus() {
        
    }
}

extension FeedCollectionViewCell {
    private func configureCell() {
        configureContentView()
        configureProfileImage()
        configureLikeAndUpVoteButtons()
        configureCirclesContainer()
        configureStatusesView()
        configureMediaStatusView()
        canvas.layer.cornerRadius = Const.View.radius
//        canvas.addShadow()
    }
    
    private func configureStatusesView() {
        statusesView.autoresizingOff()
        canvas.addSubview(statusesView)
        statusesView --> canvas
        canvas.clipsToBounds = true
        statusesView.clipsToBounds = true
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
        likeAndUpVoteVStack.bottomAnchor --> circlesContainer.topAnchor
        likeAndUpVoteVStack.trailingAnchor --> contentView.trailingAnchor + -Const.View.m16
    }
    
    private func configureMediaStatusView() {
        mediaStatus.autoresizingOff()
        contentView.addSubview(mediaStatus)
        mediaStatus.bottomAnchor --> circlesContainer.topAnchor + -Const.View.m8
        mediaStatus.leadingAnchor --> contentView.leadingAnchor + Const.View.m16
        mediaStatus.isHidden = true
        mediaStatus.trailingAnchor --> likeAndUpVoteVStack.leadingAnchor + -Const.View.m8
    }
}
