//
//  ViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/02.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let presenter: StatusPresenter = HomeScreenPresenter()
    var layout: UICollectionViewFlowLayout!
    
    let reuseIdentifier = String(describing: StatusCollectionViewCell.self)

    @IBOutlet weak var postButton: UIButton! {
        didSet {
            postButton.layer.cornerRadius = postButton.frame.height / 2
            postButton.clipsToBounds = true
            postButton.backgroundColor = .systemRed
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .systemGray5
            collectionView.collectionViewLayout = StatusCollectionViewFlowLayout()
            
            collectionView.register(
                UINib(nibName: reuseIdentifier, bundle: nil),
                forCellWithReuseIdentifier: reuseIdentifier
            )
            
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        navigationController?.title = "Some" // the next screen therofre will get this title
//        navigationController?.toolbarItems = createToolbarItems()
//        navigationController?.setToolbarItems(createToolbarItems(), animated: false)
//        navigationController?.setToolbarHidden(false, animated: true)
       
    }
    
    func createToolbarItems() -> [UIBarButtonItem] {
        return [
            UIBarButtonItem(title: "Feed", style: .plain, target: self, action: #selector(goToFeed)),
            UIBarButtonItem(title: "Notifications", style: .plain, target: self, action: #selector(goNotifications)),
            UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goProfile))
        ]
    }
    
    @IBAction func postButtonAction(_ sender: Any) {
        let viewController = PostStatusViewController()
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func goToFeed() {
        
    }
    
    @objc func goProfile() {
        
    }
    
    @objc func goNotifications() {
        
    }
    
}



extension ViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.statusCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let status = presenter.getStatus(at: indexPath)
        let cell = collectionView.deque(StatusCollectionViewCell.self, at: indexPath)
        presenter.statusCellPresenter.configure(with: cell, forDisplaying: status)
        return cell
    }
}
