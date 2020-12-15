//
//  CaptureStatusCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/12/02.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol CaptureStatusCoordinator: Coordinator {
    func startCaptureStatusViewController()
}

extension HomeCoordinator: CaptureStatusCoordinator  {
    func startCaptureStatusViewController() {
        let viewController = CaptureStatusViewController()
        viewController.coordinator = self
//        viewController.presenter = TrimVideoViewPresenterImplementation(videoURL: videoURL)
        let trimVideoNavigationController = UINavigationController(rootViewController: viewController)
        trimVideoNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(trimVideoNavigationController, animated: true)
        navigationController = trimVideoNavigationController
    }
}
