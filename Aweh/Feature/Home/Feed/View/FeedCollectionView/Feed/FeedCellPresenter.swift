//
//  StatusCellPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/06.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

class FeedCellPresenter {
    func configure(with cell: FeedCollectionViewCell, forDisplaying model: StatusViewModel) {
        cell.userName.text = model.user.name // change this to attributed string
        cell.statusText.text = model.status
        cell.distanceAndTime.text = model.distanceFromYou + "KM・\(model.timeSincePosted)" // change this to attributed string
        
    }
    
    private func getVotesString(votes: Int) -> String {
        return votes >= 0 ? "" : "\(votes)"
    }
    
    func didSelectItem(viewModel: StatusViewModel) {
        // TODO: - some logic when the cell is selected
    }
    
    func setLikeAndVoteButtonsActions(for cell: FeedCollectionViewCell,
                                      didTapLikeButton: @escaping () -> Void,
                               didTapDownVoteButton: @escaping () -> Void,
                               didTapUpVoteButton: @escaping () -> Void) {
        
        cell.likeAndUpVoteHStack.didTapUpVoteAction = didTapUpVoteButton
        cell.likeAndUpVoteHStack.didTapDownVoteAction = didTapDownVoteButton
        cell.likeAndUpVoteHStack.didTapLikeAction = didTapLikeButton
    }
}
