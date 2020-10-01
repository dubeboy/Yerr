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
    func fetchComments(page: Int,
                       completion: @escaping (Int) -> Void,
                       failuire: @escaping (String) -> Void
    )
    
    func postComment(comment: String, completion: @escaping Completion<DetailCommentViewModel>, error: @escaping Completion<String>)
}

class FeedDetailPresenterImplemantation: FeedDetailPresenter {
    let title: String = "Status"
    let feedDetailCellPresenter: FeedDetailCellPresenter = FeedDetailCellPresenter()
    let commentsPresenter: CommentCellPresenter = CommentCellPresenter()
    var viewModel: FeedDetailViewModel
    var feedDetailInteratctor = FeedDetailInteractor()
    
    var commentsCount: Int {
        viewModel.comments.count
    }
    
    init(statusViewModel: FeedDetailViewModel) {
        self.viewModel = statusViewModel
    }
    
    func configure(_ cell: FeedDetailCollectionViewCell) {
        feedDetailCellPresenter.configure(with: cell, forDisplaying: viewModel)
    }
    
    func configure(_ cell: CommentCollectionViewCell, for indexPath: IndexPath) {
        let commentViewModel = viewModel.comments[indexPath.item - 1]
        commentsPresenter.configure(with: cell, forDisplaying: commentViewModel)
    }
    
    func fetchComments(page: Int,
                       completion: @escaping (Int) -> Void,
                       failuire: @escaping (String) -> Void
    )  {
        feedDetailInteratctor.getComments(statusId: viewModel.feed.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let result):
                    self.viewModel.comments.append(contentsOf: result.map(DetailCommentViewModel.tranform(comment:))
                    ) 
                    completion(self.viewModel.comments.count)
                case .failure(let error):
                    failuire(error.localizedDescription)
            }
        }
    }
    
    func postComment(comment: String, completion: @escaping Completion<DetailCommentViewModel>, error: @escaping Completion<String>) {
        var commentEntity = Comment(body: comment,
                                    user: .dummyUser,
                                    media: [],
                                    createdAt: Date(), // TODO should be nullable
                                    location: .dummyLocation,
                                    id: nil)
        feedDetailInteratctor.postComments(statusId: viewModel.feed.id, comment: commentEntity) { result in
            switch result {
                case .success(let result):
                    commentEntity.id = result
                    let newComment = DetailCommentViewModel.tranform(comment: commentEntity)
                    self.viewModel.comments.insert(newComment, at: 0)
                    completion(newComment)
                case .failure(let e):
                    error(e.localizedDescription)
            }
        }
    }
}
