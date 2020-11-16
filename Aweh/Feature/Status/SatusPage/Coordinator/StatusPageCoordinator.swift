//
//  InterestCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

protocol StatusPageCoordinator: AnyObject {
    func createStatusPageViewController() -> StatusPageViewController
}

extension HomeCoordinator: StatusPageCoordinator {

    func createStatusPageViewController() -> StatusPageViewController {
        let viewController = StatusPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
//        viewController.coordinator = self
        viewController.presenter = StatusPagePresenterImplemantation()
        return viewController
    }
}
