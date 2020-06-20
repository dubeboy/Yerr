//
//  FeedDetailPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/17.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol FeedDetailPresenter {
    var commentsCount: Int { get }
    var title: String { get }
    func configure(_ cell: FeedDetailCollectionViewCell)
    func configure(_ cell: CommentCollectionViewCell, for indexPath: IndexPath)
    func fetchComments(page: Int, completion: @escaping (_ count: Int) -> Void)
}

class FeedDetailPresenterImplemantation: FeedDetailPresenter {
    let title: String = "Status"
    let feedDetailCellPresenter: FeedDetailCellPresenter = FeedDetailCellPresenter()
    let commentsPresenter: CommentCellPresenter = CommentCellPresenter()
    var viewModel: FeedDetailViewModel
    
    var commentsCount: Int {
        viewModel.comments?.count ?? 0
    }
    
    init(statusViewModel: FeedDetailViewModel) {
        self.viewModel = statusViewModel
    }
    
    func configure(_ cell: FeedDetailCollectionViewCell) {
        feedDetailCellPresenter.configure(with: cell, forDisplaying: viewModel)
    }
    
    func configure(_ cell: CommentCollectionViewCell, for indexPath: IndexPath) {
        let commentViewModel = viewModel.comments?[indexPath.item - 1]
        guard let viewModel = commentViewModel else { return }
        commentsPresenter.configure(with: cell, forDisplaying: viewModel)
    }
    
    func fetchComments(page: Int, completion: @escaping (_ count: Int) -> Void) {
        viewModel.comments = Self.commentsStub().map(DetailCommentViewModel.tranform(comment:))
        completion(viewModel.comments?.count ?? 0)
    }
    
    static func commentsStub() -> [Comment] {
        [Comment(name: "Joe", timestamp: Date(), comment: "nice nice.", userImageURL: "1"),
        Comment(name: "Joe", timestamp: Date(), comment: "really really really long text option 3. is really looong ey I have to say its lengthy", userImageURL: "2"),
        Comment(name: "Dave Chapel", timestamp: Date(), comment: "nice nice.", userImageURL: "1"),
        Comment(name: "Seth Kooth", timestamp: Date(timeIntervalSinceNow: 60 * 60 * 24 * 2), comment: "Thank you so much man", userImageURL: "1"),
        Comment(name: "Some random text", timestamp: Date(), comment: "You name is whack!!!!!😅🚨🔥", userImageURL: "1"),
         Comment(name: "Some random text 333", timestamp: Date(), comment: "You name is whack!!!!!😅🚨🔥", userImageURL: "1"),
          Comment(name: "Long name", timestamp: Date(), comment: "You name is whack!!!!!😅🚨🔥", userImageURL: "1")
        ]
    }
}
