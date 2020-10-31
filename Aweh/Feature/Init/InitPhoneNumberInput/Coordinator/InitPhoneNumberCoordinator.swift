//
//  InitPhoneNumberCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/27.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation


import Foundation

protocol InitPhoneNumberCoordinator {
    func createInitPhoneNumberViewController() -> InitPhoneNumberInputViewController
    func startInitPhoneNumberCoordinatorViewController()
}

extension InitScreensCoordinator: InitPhoneNumberCoordinator  {
    func createInitPhoneNumberViewController() -> InitPhoneNumberInputViewController {
        navigationController.delegate = self
        let mainViewController = InitPhoneNumberInputViewController()
        mainViewController.coordinator = self
        mainViewController.presenter = InitPhoneNumberInputPresenterImplementation()
        return mainViewController
    }
    
    func startInitPhoneNumberCoordinatorViewController() {
        let viewController = createInitPhoneNumberViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

