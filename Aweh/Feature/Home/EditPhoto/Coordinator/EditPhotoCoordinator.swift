//
//  EditVideoCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/05.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

protocol EditPhotoCoordinator: Coordinator {
    func startEditPhotoCoordinator(navigationController: UINavigationController?, imageAssetData: [Data])
}


extension HomeCoordinator: EditPhotoCoordinator {
    func startEditPhotoCoordinator(navigationController: UINavigationController?, imageAssetData: [Data]) {
        let viewController = EditPhotoViewController()
        viewController.coordinator = self
        viewController.presenter = EditPhotoPresenterImplementation(imageData: imageAssetData)
        navigationController?.pushViewController(viewController, animated: false)
    }
}
