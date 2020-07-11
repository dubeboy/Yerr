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
    
    @IBOutlet weak var containerStackView: UIStackView!
    var presenter: ProfilePresenter = ProfilePresenterImplementation()
    var coordinator: MainProfileCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.profileImage  { [weak self] image in
            self?.pointsView.userImage.image = image
            self?.pointsView.userImage.makeImageRound()
        }
        
        guard let points = presenter.points else { return }
        pointsView.set(values: points)
        stylePointDescriptionView()
    }
    
    @IBAction func interestsButton(_ sender: Any) {
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
