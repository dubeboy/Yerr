//
//  FeedCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/15.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol FeedCoordinator: AnyObject {
    func startFeedViewController(forInterestName: String)
    func startFeedViewController()

    func createFeedViewController() -> FeedViewController
}

extension HomeCoordinator: FeedCoordinator {    
    func startFeedViewController() {
        let mainViewController = createFeedViewController()
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func createFeedViewController() -> FeedViewController {
        navigationController.delegate = self
        let mainViewController = FeedViewController.instantiate()
        mainViewController.coordinator = self
        mainViewController.title = "Feed"
        mainViewController.presenter = FeedPresenterImplemantation()
        return mainViewController
    }
    
    func startFeedViewController(forInterestName: String) {
        let mainViewController = createFeedViewController()
        mainViewController.interestName = forInterestName
        navigationController.pushViewController(mainViewController, animated: true)
    }
}
