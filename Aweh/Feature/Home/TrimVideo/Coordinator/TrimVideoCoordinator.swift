//
//  TrimVideoViewCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol TrimVideoCoordinator: Coordinator {
    func startTrimVideoViewController(navigationController: UINavigationController?, videoURL: URL, delegate: @escaping Completion<()>)
}

extension HomeCoordinator: TrimVideoCoordinator  {
    func startTrimVideoViewController(navigationController: UINavigationController?, videoURL: URL, delegate: @escaping Completion<()>) {
        let viewController = TrimVideoViewController()
        viewController.coordinator = self
//        viewController.delegate = delegate
        viewController.presenter = TrimVideoViewPresenterImplementation(videoURL: videoURL)
        let trimVideoNavigationController = UINavigationController(rootViewController: viewController)
        trimVideoNavigationController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController, animated: false)
    }
}

