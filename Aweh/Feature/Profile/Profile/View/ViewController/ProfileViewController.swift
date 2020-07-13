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
