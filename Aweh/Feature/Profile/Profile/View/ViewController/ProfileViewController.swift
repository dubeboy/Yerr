//
//  ProfileViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var halfSectionView: UIView!
    @IBOutlet weak var statusesCollectionView: UICollectionView!
    var profilePictureView: ProfilePictureView = ProfilePictureView()
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var containerStackView: UIStackView!
    var presenter: ProfilePresenter = ProfilePresenterImplementation()
    var coordinator: MainProfileCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfileImageView()
        presenter.profileImage { [weak self] imageURL in
            guard let self = self else { return }
            
            self.profilePictureView.downloadImage(url: imageURL)
        }
        
        stylePointDescriptionView()
        navigationController?.view.backgroundColor = .red
        navigationItem.rightBarButtonItems = [
            .init(
                title: "Interests",
                style: .plain,
                target: self,
                action: #selector(interestsButton)
            ),
//            .init(title: "Settings",
//                  style: .plain,
//                  target: self,
//                  action: #selector(settings)
//            )
        ]
        
        halfSectionView.addDividerLine(to: [.top, .bottom])
    }
     
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionView()
    }
    
   
    
    @objc func settings(_ sender: Any) {
        
    }
    
    @objc func interestsButton(_ sender: Any) {
//        coordinator.startStatusViewController(
//
//        )
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfStatuses
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(CompactFeedCollectionViewCell.self, at: indexPath)
        return cell
    }
}


// MARK: Private functions
extension ProfileViewController {
    private func configureSelf() {
        
    }
    
    private func configureProfileImageView() {
        self.view.addSubview(profilePictureView)
        profilePictureView.autoresizingOff()
        profileView.addSubview(profilePictureView)
        profilePictureView --> profileView
    }
    
    private func configureCollectionView() {
        guard let layout = statusesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        statusesCollectionView.showsHorizontalScrollIndicator = false
        let collectionViewBounds = statusesCollectionView.bounds
        layout.minimumInteritemSpacing = Const.View.m8
        layout.minimumInteritemSpacing = Const.View.m8
        layout.minimumLineSpacing = Const.View.m8
        layout.sectionInset = UIEdgeInsets(
            top: Const.View.m8,
            left: Const.View.m16,
            bottom: Const.View.m8,
            right: Const.View.m16
        )
        let cellHeight = collectionViewBounds.height -
            (layout.sectionInset.top +
                layout.sectionInset.bottom) -
            (statusesCollectionView.contentInset.top +
                statusesCollectionView.contentInset.bottom)
        
        let cellSize = CGSize(width: 150, height: cellHeight)
        layout.itemSize = cellSize
        layout.scrollDirection = .horizontal
        //        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        statusesCollectionView.dataSource = self
        statusesCollectionView.register(CompactFeedCollectionViewCell.self)
    }
    
    private func stylePointDescriptionView() {
        containerStackView.arrangedSubviews.forEach { view in
            view.layer.cornerRadius = Const.View.radius
            view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.5)
        }
    }
}
