//
//  PhotosCollectionViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/10.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit
import Photos

enum SelectionType {
    case show
    case select(_ isSelected: Bool)
}


protocol PhotosCollectionViewPresenter {
    func loadImages(for size: CGSize, imageCount: (_ count: Int) -> Void)
    func getImage(at indexPath: IndexPath,
                  targetSize: CGSize,
                  completion: @escaping (_ image: UIImage?, _ selected: Bool) -> Void)
    func imageCount() -> Int
    func didSelectItem(at index: IndexPath, selectionState: (_ isSelected: SelectionType) -> Void)
    func getItem(at index: IndexPath) -> PHAsset?
    func selectMode(mode: (_ selectionMode: Bool) -> Void)
    func done(images: (_ selectedImages: [String: PHAsset]) -> Void)
}

class PhotosCollectionViewPresenterImplemantation: PhotosCollectionViewPresenter {

    var multiSelectionEnabled: Bool = false
    private let manager = PHImageManager.default()
    private var images: PHFetchResult<PHAsset>?
    private var selectedImages = [String: PHAsset]()
    
    // some callback arent required
    func loadImages(for size: CGSize, imageCount: (_ count: Int) -> Void) {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d",
                                         PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        images = PHAsset.fetchAssets(with: options)
    }
    
    func getImage(at indexPath: IndexPath,
                              targetSize: CGSize,
                              completion: @escaping (_ image: UIImage?, _ selected: Bool) -> Void) {
        guard let asset = getItem(at: indexPath) else { return }
            manager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: nil
            ) { image, arg  in
                completion(image, self.selectedImages[asset.localIdentifier] != nil)
            }
    }
    
    func imageCount() -> Int {
        return images?.count ?? 0
    }
    
    func didSelectItem(at index: IndexPath,
                       selectionState: (_ isSelected: SelectionType) -> Void) {
        if !multiSelectionEnabled {
            selectionState(SelectionType.show) // beef up to show the video of image
        } else {
            multiSelect(at: index, selectionState: selectionState)
        }
    }

    
    private func multiSelect(at index: IndexPath,
                             selectionState: (_ isSelected: SelectionType) -> Void) {
        guard let images = images else { return }
        let asset = images.object(at: index.item)
        if selectedImages[asset.localIdentifier] == nil { // it has not been selected yet
            selectedImages[asset.localIdentifier] = asset
            selectionState(SelectionType.select(true))
        } else {
            selectedImages.removeValue(forKey: asset.localIdentifier)
            selectionState(SelectionType.select(false))
        }
    }
    
    func getItem(at index: IndexPath) -> PHAsset? {
        return images?.object(at: index.item)
    }
    
    func selectMode(mode: (_ selectionMode: Bool) -> Void) {
        multiSelectionEnabled = !multiSelectionEnabled
        selectedImages.removeAll()
        mode(multiSelectionEnabled)
    }
    
    func done(images: (_ selectedImages: [String: PHAsset]) -> Void) {
        images(selectedImages)
    }
}
