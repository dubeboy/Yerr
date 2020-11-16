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
                     forDisplaying model: StatusViewModel,
                     statusPageCoordinator: StatusPageCoordinator,
                     parentViewController: FeedViewController) {
        
        cell.coordinator = statusPageCoordinator
        cell.parentViewController = parentViewController
        cell.loadContent(with: model.statusPageViewModel)
        cell.userName.text = model.user.name // change this to attributed string
        cell.distance.text = model.distanceFromYou + "KM・\(model.timeSincePosted)" // change this to attributed string
        cell.likeAndUpVoteVStack.setUpVoteText(text: getVotesString(votes: model.votes))
        cell.likeAndUpVoteVStack.setDownVoteText(text: getVotesString(votes: model.votes))
        cell.likeAndUpVoteVStack.setLikeVoteText(text: getVotesString(votes: model.likes))
    }
    
    private func getVotesString(votes: Int) -> String {
        return votes == 0 ? "" : "\(votes)"
    }
    
    func didSelectItem(viewModel: StatusViewModel) {
        // TODO: - some logic when the cell is selected
    }
    
    func setLikeAndVoteButtonsActions(for cell: FeedCollectionViewCell,
                                      didTapLikeButton: @escaping () -> Void,
                               didTapDownVoteButton: @escaping () -> Void,
                               didTapUpVoteButton: @escaping () -> Void) {
        
        cell.likeAndUpVoteVStack.didTapUpVoteAction = didTapUpVoteButton
        cell.likeAndUpVoteVStack.didTapDownVoteAction = didTapDownVoteButton
        cell.likeAndUpVoteVStack.didTapLikeAction = didTapLikeButton
    }
    
}
