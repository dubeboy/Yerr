//
//  ImagesPreviewView.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/09.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

class ImagesPreviewView: UIView {
    
    let presenter: PhotosCollectionViewPresenter
    
    @LateInit
    private var collectionView: UICollectionView
    private let itemSize: CGSize
    
    private let dragView = UIView() // This should have a disappeating text view with instruction
   
    init(itemSize: CGSize, presenter: PhotosCollectionViewPresenter) {
        self.itemSize = itemSize
        self.presenter = presenter
        super.init(frame: .zero)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
       
    }
}

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
        
        presenter.loadImages(for: itemSize) { _ in }
    }
}

extension ImagesPreviewView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.imageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // should move this to the cell presenter
        let cell = collectionView.deque(PhotosCollectionViewCell.self, at: indexPath)
        
        let asset = presenter.getItem(at: indexPath)
        cell.representationItemIndetifier = asset?.localIdentifier ?? ""
        
        // check memory leak
        presenter.getImage(
            at: indexPath,
            targetSize: cell.bounds.size
        ) { image, isSelected in
            if cell.representationItemIndetifier == asset?.localIdentifier ?? "" {
                cell.isSelected = isSelected
                cell.imageView.image = image
            }
        }
        
        return cell
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
        
    }
}


