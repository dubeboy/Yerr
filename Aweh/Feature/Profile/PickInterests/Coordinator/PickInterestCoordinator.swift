//
//  PickInterestCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/05.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol PickInterestCoordinator {
    func startPickInterestViewController(viewModel: UserViewModel)
}

extension ProfileCoordinator: PickInterestCoordinator {
    func startPickInterestViewController(viewModel: UserViewModel) {
        let viewController = PickInterestCollectionViewController.instantiate()
        viewController.coordinator = self
        let pickInterestPresenter =
            PickInterestPresenterImplementation(viewModel: IntrestsPresenterImplemantation.stub())
        viewController.presenter = pickInterestPresenter
        navigationController.pushViewController(viewController, animated: true)
    }
}
