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
    func startStatusPageViewController(viewModel: InterestViewModel)
}

extension StatusCoordinator: StatusPageCoordinator {
    func startStatusPageViewController(viewModel: InterestViewModel) {
        let viewController = StatusPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        viewController.coordinator = self
        viewController.presenter = StatusPagePresenterImplemantation(with: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
