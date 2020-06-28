//
//  StatusCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol SingleStatusCoordinator {
    func createSingleStatusViewController(viewModel: SingleStatusViewModel) -> SingleStatusViewController
}

extension StatusCoordinator: SingleStatusCoordinator {
    func createSingleStatusViewController(viewModel: SingleStatusViewModel) -> SingleStatusViewController {
        let viewController = SingleStatusViewController.instantiate()
        viewController.coordinator = self
        viewController.presenter = SingleStatusPresenterImplementation(viewModel: viewModel)
        return viewController
    }
}

