//
//  ProfileViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var stausesCollectionView: UICollectionView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    var presenter: ProfilePresenter = ProfilePresenterImplementation()
    var coordinator: ProfileCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylePointsView()
        makeProfileImageRound()
        presenter.profileImage  { [weak self] image in
            self?.userProfileImage.image = image
        }
    }
    
    @IBAction func interestsButton(_ sender: Any) {
        
    }
    private func makeProfileImageRound() {
        userProfileImage.makeImageRound()
    }
    
    private func stylePointsView() {
        pointsView.layer.cornerRadius = pointsView.bounds.size.height / 2
        pointsView.layer.borderColor = UIColor.red.cgColor
        pointsView.layer.borderWidth = Const.view.borderWidth
    }
}
