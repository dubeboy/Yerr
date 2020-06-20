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
    
    let reuseIdentifier = FeedCollectionViewCell.reuseIdentifier

    @IBOutlet weak var postButton: UIButton! {
        didSet {
            configurePostButton()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
           configureCollectionView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData() // initiate the load data
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemGray5
        collectionView.collectionViewLayout = FeedCollectionViewFlowLayout()
        
        collectionView.register(
            UINib(nibName: reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifier
        )
        let layout = collectionView.collectionViewLayout as! FeedCollectionViewFlowLayout
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configurePostButton() {
        postButton.layer.cornerRadius = postButton.frame.height / 2
        postButton.clipsToBounds = true
        postButton.backgroundColor = .systemRed
    }
    
    @IBAction func postButtonAction(_ sender: Any) {
        coordinator.startPostStatusViewController()
    }
    
//    func createToolbarItems() -> [UIBarButtonItem] {
//        return [
//            UIBarButtonItem(title: "Feed", style: .plain, target: self, action: #selector(goToFeed)),
//            UIBarButtonItem(title: "Notifications", style: .plain, target: self, action: #selector(goNotifications)),
//            UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goProfile))
//        ]
//    }
//
 
//
//    @objc func goToFeed() {
//
//    }
//
//    @objc func goProfile() {
//
//    }
//
//    @objc func goNotifications() {
//
//    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.statusCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let status = presenter.getStatus(at: indexPath)
        let cell = collectionView.deque(FeedCollectionViewCell.self, at: indexPath)
        // TODO: - move to the presenter
        presenter.feedCellPresenter.configure(with: cell, forDisplaying: status)
        return cell
    }
    
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // this should be started from the presenter
        coordinator.startFeedDetailViewController(feedViewModel: presenter.getStatus(at: indexPath))
    }
}
