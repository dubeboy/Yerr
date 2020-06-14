//
//  PhotosGalleryCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/12.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import Photos

protocol PhotosGalleryCoordinator: AnyObject {
    func startPhotosGalleryViewController(completion: @escaping (([String: PHAsset]) -> Void))
}

extension MainCoordinator: PhotosGalleryCoordinator {
    func startPhotosGalleryViewController(completion: @escaping (([String: PHAsset]) -> Void)) { // call back here to pass the data back !!!
        let viewController = PhotosCollectionViewController.instantiate()
//        viewController.modalPresentationStyle = .fullScreen
        viewController.coordinator = self
        viewController.completion = completion
//        navigationController.present(viewController, animated: true, completion: nil)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func done() {
        navigationController.popViewController(animated: true)
    }
}
