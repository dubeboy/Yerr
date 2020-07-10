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
    @IBOutlet weak var pointsView: GaugeView!
    
    var presenter: ProfilePresenter = ProfilePresenterImplementation()
    var coordinator: PickInterestCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.profileImage  { [weak self] image in
            self?.pointsView.userImage.image = image
            self?.pointsView.userImage.makeImageRound()
        }
        
        guard let points = presenter.points else { return }
        pointsView.set(values: points)
    }
    
    @IBAction func interestsButton(_ sender: Any) {
        coordinator.startPickInterestViewController(
            viewModel: presenter.viewModel
        )
    }
}
