//
//  TrimVideoViewCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol TrimVideoCoordinator: Coordinator {
    func startPostStatusViewController(delegate: @escaping Completion<StatusViewModel>)
}

extension HomeCoordinator: TrimVideoCoordinator  {
    func startTrimVideoViewController(videoURL: String, delegate: @escaping Completion<()>) {
        let viewController = TrimVideoViewController()
        viewController.coordinator = self
//        viewController.delegate = delegate
        viewController.presenter = TrimVideoViewPresenterImplementation(videoURL: videoURL)
        let trimVideoNavigationController = UINavigationController(rootViewController: viewController)
        trimVideoNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(trimVideoNavigationController, animated: true)
    }
}

