//
//  PhotosGalleryCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/12.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import Photos

protocol PhotosGalleryCoordinator: Coordinator {
    func startPhotosGalleryViewController(navigationController: UINavigationController?,
                                          completion: @escaping (([String: PHAsset]) -> Void))
}

extension HomeCoordinator: PhotosGalleryCoordinator {
    func startPhotosGalleryViewController(navigationController: UINavigationController?,
                                          completion: @escaping (([String: PHAsset]) -> Void)) {
        let viewController = PhotosCollectionViewController()
        viewController.coordinator = self
        viewController.completion = completion
        viewController.presenter = PhotosCollectionViewPresenterImplemantation()
        // TODO: check if iOS 14 then lauch the phos iOS 14
        
        let photosNavigationController = UINavigationController(rootViewController: viewController)
        photosNavigationController.modalPresentationStyle = .fullScreen
        navigationController?.present(photosNavigationController, animated: true, completion: nil)
    }
    
    func done() {
        navigationController.popViewController(animated: true)
    }
}
