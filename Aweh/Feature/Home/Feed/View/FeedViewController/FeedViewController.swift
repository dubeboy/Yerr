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
        // TODO: add Shimer view
        presenter.getStatuses { [weak self] count, error in
            guard let self = self else { return }
            
            guard let _ = count else {
                self.presentToast(message: .error(error))
                return
            }
            
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = Const.Color.backgroundColor
        collectionView.collectionViewLayout = FeedCollectionViewFlowLayout()
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
