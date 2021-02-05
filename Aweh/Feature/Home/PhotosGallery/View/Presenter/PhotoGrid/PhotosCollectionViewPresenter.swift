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
    
    var delegate: PhotosCollectionDelegate? { get set }
    func shouldBeableToSelect(item at: IndexPath) -> Bool
    func shouldBeableToDeSelect() -> Bool
    var isSelectingImages: Bool { get }
    
    func loadImages(for size: CGSize, imageCount: (_ count: Int) -> Void)
    func getImage(at indexPath: IndexPath,
                  targetSize: CGSize,
                  completion: @escaping (_ image: UIImage?, _ selected: Bool, _ isSelectable: Bool) -> Void)
    func imageCount() -> Int
    func didSelectItem(at index: IndexPath, selectionState: (_ isSelected: SelectionType) -> Void)
    func getItem(at index: IndexPath) -> PHAsset?
    func selectMode(mode: (_ selectionMode: Bool) -> Void)
    func done(images: (_ selectedImages: [PHAsset]) -> Void)
    func getDuration(indexPath: IndexPath) -> String
    
}

protocol PhotosCollectionDelegate: AnyObject {
    func shouldUpdateCollectionViewState()
    func imageCountDidChange(count: Int, hasVideoContent: Bool)
}

class PhotosCollectionViewPresenterImplemantation: PhotosCollectionViewPresenter {
    weak var delegate: PhotosCollectionDelegate?
    var multiSelectionEnabled: Bool = false
    private let manager = PHImageManager.default()
    private var images: PHFetchResult<PHAsset>?
    private var hasVideoContent = false
    private var doNotStopSelection = true
    
    private var selectedImages = [PHAsset]() {
        didSet {
           
            if selectedImages.count == 1 {
                guard let value = selectedImages.first else { return }
                if value.mediaType == .video {
                    hasVideoContent = true
                } else {
                    hasVideoContent = false
                }
                delegate?.shouldUpdateCollectionViewState()
            } else if selectedImages.count == 0 {
                doNotStopSelection = true
                delegate?.shouldUpdateCollectionViewState()
            } else if selectedImages.count >= 10 {
                doNotStopSelection = false
                delegate?.shouldUpdateCollectionViewState()
            } else if selectedImages.count == 9 {
                delegate?.shouldUpdateCollectionViewState()
            } else {
                doNotStopSelection = true
            }
            
            delegate?.imageCountDidChange(count: selectedImages.count, hasVideoContent: hasVideoContent)

        }
    }
    
    var isSelectingImages: Bool {
        !hasVideoContent
    }
    
    func shouldBeableToSelect(item at: IndexPath) -> Bool {
        guard let asset = getItem(at: at) else { return false }
        if selectedImages.count == 0 {
            return true
        } else if imageCount() > 0 && asset.mediaType == .video  {
            return false
        } else {
            return doNotStopSelection
        }
    }
    
    func shouldBeableToDeSelect() -> Bool {
        if doNotStopSelection {
            return true
        } else if selectedImages.count <= 10 && !doNotStopSelection {
            doNotStopSelection = true
//            delegate?.shouldUpdateCollectionViewState()
            return true
        }
        return true
    }
    
    // some callback arent required
    func loadImages(for size: CGSize, imageCount: (_ count: Int) -> Void) {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d",
                                         PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.includeAssetSourceTypes = [.typeiTunesSynced, .typeUserLibrary]
        images = PHAsset.fetchAssets(with: options) // TOCO check if all images are fetched at once
    }
    
    func getDuration(indexPath: IndexPath) -> String {
        guard let asset = getItem(at: indexPath) else { return "" }
        if asset.mediaType == .video {
            let (hour, minute, seconds) = getFormattedVideoTime(totalVideoDuration: Int(asset.duration))
            if hour > 0 {
               return  String(format: "%.2d:%.2d:%.2d", hour, minute, seconds)
            } else {
                return  String(format: "%.2d:%.2d", minute, seconds)
            }
        } else {
            return ""
        }
    }
    
    private func getFormattedVideoTime(totalVideoDuration: Int) -> (hour: Int, minute: Int, seconds: Int) {
        let seconds = totalVideoDuration % 60
        let minutes = (totalVideoDuration / 60) % 60
        let hours   = totalVideoDuration / 3600
        return (hours,minutes,seconds)
    }
    
    func getImage(at indexPath: IndexPath,
                              targetSize: CGSize,
                              completion: @escaping (_ image: UIImage?, _ selected: Bool, _ isSelectable: Bool) -> Void) {
        guard let asset = getItem(at: indexPath) else { return }
        
        var isSelectable = true
        if !selectedImages.isEmpty {
            if hasVideoContent {
                isSelectable = asset.mediaType == .video ? true : false
            } else {
                isSelectable = asset.mediaType == .image ? true : false
            }
        }
            manager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: nil
            ) { image, arg  in
                completion(image, self.containsItem(item: asset) != nil, self.doNotStopSelection && isSelectable)
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
        if containsItem(item: asset) == nil {
            selectedImages.append(asset)
            selectionState(SelectionType.select(true))
        } else {
            removeItem(item: asset)
            selectionState(SelectionType.select(false))
        }
    }
    
    // O(10)
    private func containsItem(item: PHAsset) -> PHAsset? {
        selectedImages.first { $0.localIdentifier == item.localIdentifier }
    }
    
    private func removeItem(item: PHAsset) {
        guard let indexToRemove = selectedImages.firstIndex(of: item) else { return }
        selectedImages.remove(at: indexToRemove)
    }
    
    func getItem(at index: IndexPath) -> PHAsset? {
        return images?.object(at: index.item)
    }
    
    func selectMode(mode: (_ selectionMode: Bool) -> Void) {
        multiSelectionEnabled = !multiSelectionEnabled
        selectedImages.removeAll()
        mode(multiSelectionEnabled)
    }
    
    func done(images: (_ selectedImages: [PHAsset]) -> Void) {
        images(selectedImages)
    }
}
