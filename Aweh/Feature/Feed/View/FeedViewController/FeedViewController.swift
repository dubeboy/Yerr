//
//  ViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/02.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    let presenter: StatusPresenter = HomeScreenPresenter()
    var layout: UICollectionViewFlowLayout!
    weak var coordinator: PostStatusCoordinator!
    
    let reuseIdentifier = FeedCollectionViewCell.reuseIdentifier

    @IBOutlet weak var postButton: UIButton! {
        didSet {
            postButton.layer.cornerRadius = postButton.frame.height / 2
            postButton.clipsToBounds = true
            postButton.backgroundColor = .systemRed
            
            // use this to add a shadow !!!
//            postButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//            postButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//            postButton.layer.shadowOpacity = 1.0
//            postButton.layer.shadowRadius = 0.0
//            postButton.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .systemGray5
            collectionView.collectionViewLayout = FeedCollectionViewFlowLayout()
            
            collectionView.register(
                UINib(nibName: reuseIdentifier, bundle: nil),
                forCellWithReuseIdentifier: reuseIdentifier
            )
                        
            collectionView.dataSource = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData() // initiate the load data
    }
    
    func createToolbarItems() -> [UIBarButtonItem] {
        return [
            UIBarButtonItem(title: "Feed", style: .plain, target: self, action: #selector(goToFeed)),
            UIBarButtonItem(title: "Notifications", style: .plain, target: self, action: #selector(goNotifications)),
            UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goProfile))
        ]
    }
    
    @IBAction func postButtonAction(_ sender: Any) {
        coordinator.startPostStatusViewController()
    }
    
    @objc func goToFeed() {
        
    }
    
    @objc func goProfile() {
        
    }
    
    @objc func goNotifications() {
        
    }
    
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.statusCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let status = presenter.getStatus(at: indexPath)
        let cell = collectionView.deque(FeedCollectionViewCell.self, at: indexPath)
        presenter.statusCellPresenter.configure(with: cell, forDisplaying: status)
        return cell
    }
}
