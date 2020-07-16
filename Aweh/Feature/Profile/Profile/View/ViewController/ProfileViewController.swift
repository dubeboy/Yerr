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
    @IBOutlet weak var pointsView: GaugeView!
    
    @IBOutlet weak var containerStackView: UIStackView!
    var presenter: ProfilePresenter = ProfilePresenterImplementation()
    var coordinator: MainProfileCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.profileImage { [weak self] image in
            self?.pointsView.userImage.image = image
            self?.pointsView.userImage.makeImageRound()
        }
        
        guard let points = presenter.points else { return }
        pointsView.set(values: points)
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
    
    @objc func settings(_ sender: Any) {
        
    }
    
    @objc func interestsButton(_ sender: Any) {
        coordinator.startStatusViewController(
            userViewModel: presenter.viewModel
        )
    }
    
    private func stylePointDescriptionView() {
        containerStackView.arrangedSubviews.forEach { view in
            view.layer.cornerRadius = Const.View.radius
            view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.5)
        }
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
        presenter.statuses(at: indexPath) { [weak self] status in
            self?.presenter.cellPresenter.configure(with: cell, forDisplaying: status)
        }
        
        return cell
    }
}
