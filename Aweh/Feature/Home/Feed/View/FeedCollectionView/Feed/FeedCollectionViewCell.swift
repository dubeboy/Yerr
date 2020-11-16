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
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var songsView: UIView!
    @IBOutlet weak var circlesView: UIView!
    @IBOutlet weak var circlesContainer: UIView!
    
    var videoPlayer = StatusVideoView() // should be in StatusPage
    var likeAndUpVoteVStack: LikeAndVotesVStask = LikeAndVotesVStask()
    weak var coordinator: StatusPageCoordinator!
    weak var parentViewController: UIViewController!
    
    @LateInit
    var statusPageViewController: StatusPageViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        configureCell()
    }
    
    func loadContent(with viewModel: StatusPageViewModel) {
        statusPageViewController.setViewModel(viewModel: viewModel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusPageViewController.resetView()
    }
}

extension FeedCollectionViewCell {
    private func configureCell() {
        configureContentView()
        configureProfileImage()
        configureLikeAndUpVoteButtons()
        configureCirclesContainer()
        configureStatusPageViewController()
    }
    
    private func configureStatusPageViewController() {
        statusPageViewController = coordinator.createStatusPageViewController()
        parentViewController.addChild(statusPageViewController)
        canvas.addSubview(statusPageViewController.view)
        statusPageViewController.view.frame = canvas.bounds
        statusPageViewController.view.autoresizingOff()
        statusPageViewController.view --> canvas
        statusPageViewController.didMove(toParent: parentViewController)
    }
    
    private func configureCirclesContainer() {
        circlesContainer.layer.cornerRadius = Const.View.radius
        circlesContainer.backgroundColor = Const.Color.lightGray
    }
    
    private func configureProfileImage() {
        profileImage.makeImageRound()
    }
    
    private func configureLikeAndUpVoteButtons() {
        likeAndUpVoteVStack.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.addArrangedSubview(likeAndUpVoteVStack)
    }
}
