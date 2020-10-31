//
//  InfoInputCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol InfoInputCoordinator {
    func createInfoInputViewController() -> InfoInputViewController
    func startInfoInputViewController()
}

extension InitScreensCoordinator: InfoInputCoordinator  {
    func createInfoInputViewController() -> InfoInputViewController {
        navigationController.delegate = self
        let mainViewController = InfoInputViewController()
        mainViewController.coordinator = self
        mainViewController.presenter = InfoInputPresenterImplementation()
        return mainViewController
    }
    
    func startInfoInputViewController() {
        let viewController = createAcceptTermsAndConditionsViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

