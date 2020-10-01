//
//  AssetDetailCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/14.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import Photos

protocol AssetDetailCoordinator: Coordinator {
    func startAssetDetailViewController(navigationController: UINavigationController?,
                                        asset: PHAsset, completion: @escaping ([String: PHAsset]) -> Void)
}

extension HomeCoordinator: AssetDetailCoordinator {
    func startAssetDetailViewController(navigationController: UINavigationController?,
                                        asset: PHAsset, completion: @escaping ([String: PHAsset]) -> Void) {
        let viewController = AssetDetailViewController.instantiate()
        viewController.coordinator = self
        viewController.asset = asset
        viewController.completion = completion
        navigationController?.pushViewController(viewController, animated: true)
    }
}
