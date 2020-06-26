//
//  IntrestsViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InterestsViewController: UICollectionViewController {
    
    var numberOfCollumns: CGFloat = 2
    var presenter: IntrestsPresenter = IntrestsPresenterImplemantation()
    weak var coordinator: StatusPageCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Status" // TODO: - move to coordinator
        configureCollectionViewCell()
        presenter.fetchInterests { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func configureCollectionViewCell() {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        flowLayout.itemSize = collectionView.calculateItemSize(numberOfColumns: numberOfCollumns)
        flowLayout.estimatedItemSize = .zero
        collectionView.register(InterestsCollectionViewCell.self)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(InterestsCollectionViewCell.self, at: indexPath)
        presenter.configure(cell: cell, at: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelect(at: indexPath) { [weak self] item in
            self?.coordinator.startStatusPageViewController(viewModel: item)
        }
    }
}

//extension InterestsViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//          CGSize(width: 50, height: 50)
//    }
//}
