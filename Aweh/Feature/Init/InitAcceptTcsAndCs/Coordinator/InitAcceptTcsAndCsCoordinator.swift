//
//  InitAcceptTcsAndCsCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/22.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol InitAcceptTcsAndCsCoordinator {
    func createAcceptTermsAndConditionsViewController() -> InitAcceptTcsAndCsViewController
    func startAcceptTermsAndConditionsViewController()
}

extension InitScreensCoordinator: InitAcceptTcsAndCsCoordinator  {
    func createAcceptTermsAndConditionsViewController() -> InitAcceptTcsAndCsViewController {
        navigationController.delegate = self
        let mainViewController = InitAcceptTcsAndCsViewController()
        mainViewController.coordinator = self
        mainViewController.presenter = InitAcceptTcsAndCsPresenterImplemetation()
        mainViewController.hidesBottomBarWhenPushed = true
        return mainViewController
    }
    
    func startAcceptTermsAndConditionsViewController() {
        let viewController = createAcceptTermsAndConditionsViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

