//
//  InterestViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/13.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol InterestCoordinator: AnyObject {
    func startInterestViewController(with presenter: InterestsPresenter)
    func createInterestViewController(
        presenter: InterestsPresenter
    ) -> InterestsViewController
}

extension StatusCoordinator: InterestCoordinator {
    func startInterestViewController(with presenter: InterestsPresenter) {
        let mainViewController = createInterestViewController(presenter: presenter)
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func createInterestViewController(
        presenter: InterestsPresenter = InterestsPresenterImplemantation()
    ) -> InterestsViewController {
        navigationController.delegate = self
        let mainViewController = InterestsViewController.instantiate()
//        mainViewController.coordinator = self // TODO: why is this needed
        mainViewController.presenter = presenter
        mainViewController.title = AppStrings.Interests.title
        return mainViewController
    }
}
