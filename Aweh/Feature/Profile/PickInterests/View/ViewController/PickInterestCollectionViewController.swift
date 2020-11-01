//
//  PickInterestCollectionViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/05.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PickInterestCollectionViewController: UICollectionViewController {
    
    var presenter: PickInterestPresenter!
    
    weak var coordinator: Coordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { preconditionFailure("Expected layout to be UICollectionViewFlowLayout") }
        layout.estimatedItemSize = CGSize(width: 100, height: 60)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        collectionView.register(PickInterestCollectionViewCell.self)
        title = "Pick Interest"
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(PickInterestCollectionViewCell.self, at: indexPath)
        let interestViewModel = presenter.getInterest(at: indexPath)
        presenter.pickInterestCellPresenter.configure(cell, forDisplaying: interestViewModel)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.interestsCount()
    }
}
