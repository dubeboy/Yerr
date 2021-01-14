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
    var presenter: InterestsPresenter!
    weak var coordinator: HomeCoordinator! // TODO: Ref is lost when manually instatiated
    weak var homeCoordinator: FeedCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        collectionView.allowsMultipleSelection = presenter.isMultiSelectEnabled
        presenter.fetchInterests { [weak self] in
            self?.collectionView.reloadData()
        } failure: { [weak self] errorMessage in
            self?.presentToast(message: errorMessage)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func configureCollectionView() {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = Const.View.m8
        flowLayout.minimumLineSpacing = Const.View.m8
        flowLayout.sectionInset = .equalEdgeInsets(Const.View.m16)
        flowLayout.itemSize = collectionView.calculateItemSize(numberOfColumns: numberOfCollumns)
        flowLayout.estimatedItemSize = .zero
        flowLayout.scrollDirection = .vertical
        collectionView.registerClass(InterestsCollectionViewCell.self)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(InterestsCollectionViewCell.self, at: indexPath)
        presenter.configure(cell: cell, at: indexPath, delegate: self)
        return cell
    }
}

extension InterestsViewController: SingleInterestViewDelegate {
    func didClickSingleIntrestView(name: String) {
        homeCoordinator.startFeedViewController(forInterestName: name)
    }
}
