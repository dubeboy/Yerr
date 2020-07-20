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
        
    }
}
