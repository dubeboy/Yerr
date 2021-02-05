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
// TODO: should reload collectionVie wwafter  the user has gratented permisyion
// PHPhotoLibrary.requestAuthorization { status in



class PhotosCollectionViewController: UICollectionViewController {

    weak var coordinator: AssetDetailCoordinator?
    var presenter: PhotosCollectionViewPresenter! {
        didSet {
            presenter.delegate = self
        }
    }
    var selectButton: UIBarButtonItem!
    var completion: (([PHAsset]) -> Void)?
    var bottomToolbar = UIToolbar()
    var imageCountLabel = UILabel()
    
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
        configureSelf()
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = selectButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.contentInset.bottom = bottomToolbar.frame.height
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
        
        let duration = presenter.getDuration(indexPath: indexPath)
        cell.timeLabel.text = duration
        
        // check memory leak
        presenter.getImage(
            at: indexPath,
            targetSize: cell.bounds.size
        ) { image, isSelected, isSelectable  in
            if cell.representationItemIndetifier == asset?.localIdentifier ?? "" {
                cell.imageView.image = image
                if isSelected {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: []) // replace with cell tap gesture
                }
                cell.isSelected = isSelected
                if isSelectable {
                    cell.viewOverlay.isHidden = true
                } else {
                    if !isSelected {
                        cell.viewOverlay.isHidden = false
                        cell.viewOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                    }
                }
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        presenter.didSelectItem(at: indexPath) { selectionState in
            switch selectionState {
                case .select(let isSelected):
                    cell.isSelected = isSelected
                   
                case .show:
                    showImage(at: indexPath)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
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
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        presenter.shouldBeableToSelect(item: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        presenter.shouldBeableToDeSelect()
    }
    
    private func showImage(at indexPath: IndexPath) {
        guard let asset = presenter.getItem(at: indexPath) else { return }
        // TODO: - should use the apps naviagtor delegate to move to the 
        coordinator?.startAssetDetailViewController(navigationController: self.navigationController,
                                                    asset: asset) { asset in
            // TODO: - can append this image to a list of selected images
           
            self.dismiss(animated: true) {
                self.completion?([asset])
            }
        }
    }
}

extension PhotosCollectionViewController: PhotosCollectionDelegate {
    func shouldUpdateCollectionViewState() {
        collectionView.reloadData()
    }
    
    func imageCountDidChange(count: Int, hasVideoContent: Bool) {
        if count > 0 {
            UIView.animate(withDuration: 0.25) { [self] in
                bottomToolbar.alpha = 1
            } completion: { [self] _ in
                bottomToolbar.isHidden = false
            }
            
            imageCountLabel.text = "\(count) \(hasVideoContent ? "Video" : (count > 1 ? "Photos" : "Photo")) Seleted"
        } else {
            UIView.animate(withDuration: 0.25) { [self] in
                bottomToolbar.alpha = 0
            } completion: { [self] _ in
                bottomToolbar.isHidden = true
            }
        }
    }
}

// MARK: - Helper functions

extension PhotosCollectionViewController {
    private func configureSelf() {
        bottomToolbar.autoresizingOff()
        view.addSubview(bottomToolbar)
        bottomToolbar.bottomAnchor --> view.safeAreaLayoutGuide.bottomAnchor
        bottomToolbar.leadingAnchor --> view.leadingAnchor
        bottomToolbar.trailingAnchor --> view.trailingAnchor
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        imageCountLabel.autoresizingOff()
        imageCountLabel.font = .boldSystemFont(ofSize: 18) // TODO: move to font
        imageCountLabel.textColor = .white
        imageCountLabel.sizeToFit()
        
        let imageCountToolbarItem = UIBarButtonItem(customView: imageCountLabel)
        bottomToolbar.setItems([spacer, imageCountToolbarItem, spacer], animated: false)
        bottomToolbar.isHidden = true
    }
}
