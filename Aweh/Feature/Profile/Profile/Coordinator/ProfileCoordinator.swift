//
//  ProfileCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/11.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol MainProfileCoordinator: AnyObject {
    func startStatusViewController(userViewModel: UserViewModel)
}

extension ProfileCoordinator: MainProfileCoordinator {
    
    func startStatusViewController(userViewModel: UserViewModel) {
        let statusCoordinator = StatusCoordinator(navigationController: navigationController) // TODO: wrong guys
        let interestPresenter = InterestsPresenterImplemantation(
            user: userViewModel
        )
        statusCoordinator.startInterestViewController(with: interestPresenter)
    }
}
