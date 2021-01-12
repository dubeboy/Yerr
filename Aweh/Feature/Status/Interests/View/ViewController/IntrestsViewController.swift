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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        flowLayout.itemSize = collectionView.calculateItemSize(numberOfColumns: numberOfCollumns)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(InterestsCollectionViewCell.self, at: indexPath)
        presenter.configure(cell: cell, at: indexPath)
        return cell
    }
}
