//
//  StatusCellPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/06.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

class FeedCellPresenter {
    func configure(with cell: FeedCollectionViewCell,
                     forDisplaying model: StatusViewModel) {
        cell.setViewModel(viewModel: model.statusPageViewModel)
        if !model.statusPageViewModel.media.isEmpty {
            cell.setMediaText(text: model.statusPageViewModel.status)
        }
        cell.userName.text = model.user.name // change this to attributed string
        cell.distance.text = model.distanceFromYou + "KM・\(model.timeSincePosted)" // change this to attributed string
//        cell.likeAndUpVoteVStack.setUpVoteText(text: getVotesString(votes: model.votes))
//        cell.likeAndUpVoteVStack.setDownVoteText(text: getVotesString(votes: model.votes))
        cell.likeAndUpVoteVStack.setLikeVoteText(text: getVotesString(votes: model.likes))
    }
    
    private func getVotesString(votes: Int) -> String {
        return votes == 0 ? "" : "\(votes)"
    }
    
    func setLikeAndVoteButtonsActions(for cell: FeedCollectionViewCell,
                                      didTapLikeButton: @escaping () -> Void,
                               didTapDownVoteButton: @escaping () -> Void,
                               didTapUpVoteButton: @escaping () -> Void) {
        
        cell.likeAndUpVoteVStack.didTapUpVoteAction = didTapUpVoteButton
        cell.likeAndUpVoteVStack.didTapDownVoteAction = didTapDownVoteButton
        cell.likeAndUpVoteVStack.didTapLikeAction = didTapLikeButton
    }
    
    func setLikes(cell: FeedCollectionViewCell, likes: Int) {
        cell.likeAndUpVoteVStack.setLikeVoteText(text: getVotesString(votes: likes))
    }
}
