//
//  PhotosGalleryCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/12.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import Photos

protocol PhotosGalleryCoordinator: Coordinator {
    func startPhotosGalleryViewController(completion: @escaping (([String: PHAsset]) -> Void))
}

extension MainCoordinator: PhotosGalleryCoordinator {
    func startPhotosGalleryViewController(completion: @escaping (([String: PHAsset]) -> Void)) {
        let viewController = PhotosCollectionViewController.instantiate()
        viewController.coordinator = self
        viewController.completion = completion
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func done() {
        navigationController.popViewController(animated: true)
    }
}
