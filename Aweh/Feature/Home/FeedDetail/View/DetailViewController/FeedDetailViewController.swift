//
//  FeedDetailViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/17.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class FeedDetailViewController: UICollectionViewController {
    
    var presenter: FeedDetailPresenter!
    weak var coordinator: Coordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        title = presenter.title
        presenter.fetchComments(page: 0) { [weak self] commentsCount in
            // TODO: - show the number of comments on the top view
            // reload item 1 to n
            self?.collectionView.reloadData()
        }
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.commentsCount + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
            case 0:
            let cell = collectionView.deque(FeedDetailCollectionViewCell.self, at: indexPath)
            presenter.configure(cell)
            return cell
            default:
            let cell = collectionView.deque(CommentCollectionViewCell.self, at: indexPath)
            presenter.configure(cell, for: indexPath)
            return cell
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(FeedDetailCollectionViewCell.self)
        collectionView.register(CommentCollectionViewCell.self)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        let width = collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        layout.estimatedItemSize = CGSize(width: width, height: 100)
        layout.minimumLineSpacing = 1
        collectionView.backgroundColor = .systemGray5
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
}
