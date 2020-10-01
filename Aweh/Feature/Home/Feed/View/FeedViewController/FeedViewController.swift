//
//  ViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/02.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
  
    let presenter: FeedPresenter = FeedPresenterImplemantation()
    var layout: UICollectionViewFlowLayout!
    weak var coordinator: (PostStatusCoordinator & FeedDetailCoordinator)!
    

    @IBOutlet weak var postButton: UIButton! {
        didSet {
            configurePostButton()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed"
        configureCollectionView()
        presenter.getStatuses { [weak self] count, error in
            guard let self = self else { return }
            
            guard let _ = count else {
                self.presentToast(message: .error(error))
                return
            }
            
            self.collectionView.reloadData()
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = Const.Color.backgroundColor
       
        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.sectionInset = UIEdgeInsets(top: Const.View.m8, left: Const.View.m8, bottom: Const.View.m8, right: Const.View.m8)
        flowLayout.minimumLineSpacing = Const.View.m8
        flowLayout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsVerticalScrollIndicator = false
        flowLayout.estimatedItemSize = collectionView.calculateItemSize(numberOfColumns: 1)
        collectionView.register(FeedCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configurePostButton() {
        postButton.layer.cornerRadius = postButton.frame.height / 2
        postButton.clipsToBounds = true
        postButton.backgroundColor = .systemRed
    }
    
    @IBAction func postButtonAction(_ sender: Any) {
        coordinator.startPostStatusViewController { statusViewModel in
            self.collectionView.setContentOffset(.zero, animated: false)
            self.collectionView.performBatchUpdates {
                self.presenter.addNewStatus(statusViewModel)
                self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            } completion: { _ in }
        }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.statusCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let status = presenter.getStatus(at: indexPath)
        let cell = collectionView.deque(FeedCollectionViewCell.self, at: indexPath)
        presenter.feedCellPresenter.configure(with: cell, forDisplaying: status)
        presenter.feedCellPresenter.setLikeAndVoteButtonsActions(for: cell) { [weak self] in
            self?.presenter.didTapLikeButton(at: indexPath)
        } didTapDownVoteButton: { [weak self] in
            self?.presenter.didTapDownVoteButton(at: indexPath)
        } didTapUpVoteButton: { [weak self] in
            self?.presenter.didTapUpVoteButton(at: indexPath)
        }
        
        return cell
    }
    
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // this should be started from the presenter
        coordinator.startFeedDetailViewController(feedViewModel: presenter.getStatus(at: indexPath))
    }
}
