//
//  PhotosCollectionViewCollectionViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/10.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"

class PhotosCollectionViewController: UICollectionViewController {

    weak var coordinator: AssetDetailCoordinator?
    var presenter: PhotosCollectionViewPresenter!
    var selectButton: UIBarButtonItem!
    var completion: (([String: PHAsset]) -> Void)?
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = Const.View.m1
        flowLayout.minimumInteritemSpacing = Const.View.m1
        flowLayout.sectionInset = .equalEdgeInsets(Const.View.m1)
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photos & Videos"
        setUpCollectionView()
        selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(enableSelection))
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = selectButton
    }
    
    @objc func enableSelection() {
        presenter.selectMode { isInSelection in
            collectionView.allowsMultipleSelection = isInSelection  // todo: should also unselect all
            selectButton.title = isInSelection ? "UnSelect" : "Select"
        }
    }
    
    @objc func done() {
        presenter.done { selectedImages in
            dismiss(animated: true) {
                self.completion?(selectedImages)
            }
        }
    }
    
    private func setUpCollectionView() {
        collectionView.register(PhotosCollectionViewCell.self)
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let size = collectionView.calculateItemSize(numberOfColumns: 3)
        flowLayout.itemSize = size
        
        collectionView.delaysContentTouches = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Const.Color.backgroundColor
    
        presenter.loadImages(for: size) { count in
            collectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return presenter.imageCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
    private func showImage(at indexPath: IndexPath) {
        guard let asset = presenter.getItem(at: indexPath) else { return }
        // TODO: - should use the apps naviagtor delegate to move to the 
        coordinator?.startAssetDetailViewController(navigationController: self.navigationController,
                                                    asset: asset) { asset in
            // TODO: - can append this image to a list of selected images
           
            self.dismiss(animated: true) {
                self.completion?(asset)
            }
        }
    }
}

