//
//  FeedDetailCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/19.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol FeedDetailCoordinator: Coordinator {
    func startFeedDetailViewController(feedViewModel: StatusViewModel)
}

extension HomeCoordinator: FeedDetailCoordinator {
    func startFeedDetailViewController(feedViewModel: StatusViewModel) {
        let viewController = FeedDetailViewController.instantiate()
        viewController.coordinator = self
        let feedPresenter = FeedDetailPresenterImplemantation(statusViewModel: .tranform(feed: feedViewModel))
        viewController.presenter = feedPresenter
        navigationController.pushViewController(viewController, animated: true)
    }
}
