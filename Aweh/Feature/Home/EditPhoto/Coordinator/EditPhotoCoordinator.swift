//
//  EditVideoCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/05.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

protocol EditPhotoCoordinator: Coordinator {
    func startEditPhotoCoordinator(navigationController: UINavigationController?, imageAssetURL: URL)
}


extension HomeCoordinator: EditPhotoCoordinator {
    func startEditPhotoCoordinator(navigationController: UINavigationController?, imageAssetURL: URL) {
        let viewController = EditPhotoViewController()
        viewController.coordinator = self
        viewController.presenter = EditPhotoPresenterImplementation(assetURL: imageAssetURL)
        navigationController?.pushViewController(viewController, animated: false)
    }
}
