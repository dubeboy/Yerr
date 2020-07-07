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
    var coordinator: PickInterestCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeProfileImageRound()
        presenter.profileImage  { [weak self] image in
            self?.userProfileImage.image = image
        }
    }
    
    @IBAction func interestsButton(_ sender: Any) {
        coordinator.startPickInterestViewController(viewModel: presenter.viewModel)
        
    }
    
    private func makeProfileImageRound() {
        userProfileImage.makeImageRound()
    }
}
