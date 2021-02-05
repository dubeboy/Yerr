//
//  TrimVideoViewCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import Photos

protocol TrimVideoCoordinator: Coordinator {
    func startTrimVideoViewController(navigationController: UINavigationController?, videoURL: URL)
    func startTrimVideoViewController(navigationController: UINavigationController?, photoAsset: PHAsset)
}

extension HomeCoordinator: TrimVideoCoordinator  {
    func startTrimVideoViewController(navigationController: UINavigationController?, photoAsset: PHAsset) {
        let viewController = TrimVideoViewController()
        viewController.coordinator = self
        viewController.presenter = TrimVideoViewPresenterImplementation(photosAsset: photoAsset)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func startTrimVideoViewController(navigationController: UINavigationController?, videoURL: URL) {
        let viewController = TrimVideoViewController()
        viewController.coordinator = self
        viewController.presenter = TrimVideoViewPresenterImplementation(videoURL: videoURL)
        navigationController?.pushViewController(viewController, animated: false)
    }
}

