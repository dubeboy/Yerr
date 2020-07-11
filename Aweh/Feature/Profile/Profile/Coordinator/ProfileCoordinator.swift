//
//  ProfileCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/11.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol MainProfileCoordinator {
    func startStatusViewController()
}

extension ProfileCoordinator: MainProfileCoordinator {
    func startStatusViewController() {
        let statusCoordinator = StatusCoordinator(navigationController: self.navigationController)
        _ = statusCoordinator.start()
    }
}
