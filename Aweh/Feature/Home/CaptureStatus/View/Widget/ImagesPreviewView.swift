//
//  ImagesPreviewView.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/09.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit
import Photos

protocol ImagesPreviewViewDelegate: AnyObject {
    func didClickImage(_ photoAsset: PHAsset)
}

class ImagesPreviewView: UIView {
    
    private var presenter: PhotosCollectionViewPresenter
    
    @LateInit
    private var collectionView: UICollectionView
    private let itemSize: CGSize
    unowned var delegate: ImagesPreviewViewDelegate
    static let IMAGE_PREVIEW_HEIGHT: CGFloat = 80
    private var shouldLoadFromGallery: Bool {
        phAssets.isEmpty
    }
    private let phAssets: [PHAsset]
    
    init(presenter: PhotosCollectionViewPresenter,
         delegate: ImagesPreviewViewDelegate,
         phAssets: [PHAsset] = []) {
        
        self.itemSize = CGSize(width: Self.IMAGE_PREVIEW_HEIGHT, height: Self.IMAGE_PREVIEW_HEIGHT)
        self.presenter = presenter
        self.delegate = delegate
        self.phAssets = phAssets
        super.init(frame: .zero)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        configureSelf()
    
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - Helper functions

extension ImagesPreviewView {
    private func configureSelf() {
        collectionView.autoresizingOff()
        addSubview(collectionView)
        collectionView --> self
        collectionView.delaysContentTouches = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Const.Color.backgroundColor.withAlphaComponent(0.4)
        collectionView.register(PhotosCollectionViewCell.self)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = itemSize
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = Const.View.m1
        if shouldLoadFromGallery {
            presenter.loadImages(for: itemSize) { _ in
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - collection view delegate

extension ImagesPreviewView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shouldLoadFromGallery {
            return presenter.imageCount()
        } else {
            return phAssets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // should move this to the cell presenter
        let cell = collectionView.deque(PhotosCollectionViewCell.self, at: indexPath)
        if shouldLoadFromGallery {
            loadFromGallery(cell: cell, indexPath: indexPath)
        } else {
           loadFromAssets(cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    private func loadFromAssets(cell: PhotosCollectionViewCell, indexPath: IndexPath) {
        let asset = phAssets[indexPath.item] 
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // The handler may originate on a background queue, so
            // re-dispatch to the main queue for UI work.
            DispatchQueue.main.sync {
                //                self.progressView.progress = Float(progress)
            }
        }
        cell.viewOverlay.isHidden = true
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: itemSize,
            contentMode: .aspectFill,
            options: options
        ) { image, arg  in
            cell.imageView.image = image
        }
    }
    
    private func loadFromGallery(cell: PhotosCollectionViewCell, indexPath: IndexPath) {
        let asset = presenter.getItem(at: indexPath)
        cell.representationItemIndetifier = asset?.localIdentifier ?? ""
        
        let duration = presenter.getDuration(indexPath: indexPath)
        cell.timeLabel.text = duration
        
        // check memory leak
        presenter.getImage(
            at: indexPath,
            targetSize: cell.bounds.size
        ) { image, isSelected, isSelectable  in
            if cell.representationItemIndetifier == asset?.localIdentifier ?? "" {
                cell.isSelected = isSelected
                cell.imageView.image = image
                if isSelectable {
                    cell.viewOverlay.isHidden = true
                } else {
                    cell.viewOverlay.isHidden = false
                    cell.viewOverlay.backgroundColor = UIColor.black
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        presenter.didSelectItem(at: indexPath) { selectionState in
            switch selectionState {
                case .select(let isSelected):
                    cell.isSelected = isSelected
                case .show:
                    showImage(at: indexPath)
            }
        }
    }
    
    func showImage(at indexPath: IndexPath) {
        guard let asset = presenter.getItem(at: indexPath) else { return }
        delegate.didClickImage(asset)
    }
}

extension ImagesPreviewView: PhotosCollectionDelegate {
    func imageCountDidChange(count: Int, hasVideoContent: Bool) {
        
    }
    
    
    
    func shouldUpdateCollectionViewState() {
        collectionView.reloadData()
    }
}


